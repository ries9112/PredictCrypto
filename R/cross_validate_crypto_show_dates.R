#'@importFrom magrittr %>%
#'@importFrom dplyr arrange
#'@importFrom dplyr mutate
#'@importFrom dplyr ntile
#'@importFrom dplyr group_by
#'@importFrom dplyr filter
#'@importFrom dplyr bind_rows
#'@export
cross_validate_crypto_show_dates <- function(data, splits=5){

  # make new object
  quantiles <- data
  # create split
  for (i in 1:nrow(crypto_data)){
    quantiles$data[[i]] <-
      crypto_data$data[[i]] %>%
      arrange(rank) %>%
      arrange(date_extracted) %>%
      mutate(split = ntile(date_extracted, splits))
  }

  # create train data with first 70% of dates
  quantiles_train <- quantiles
  for (i in 1:nrow(crypto_data)){
    quantiles_train$data[[i]] <- quantiles$data[[i]] %>%
      group_by(split) %>%
      mutate(training='train') %>%
      filter(date_extracted <= quantile(date_extracted, .7))
  }

  # create test data with last 70% of dates
  quantiles_test <- quantiles
  for (i in 1:nrow(crypto_data)){
    quantiles_test$data[[i]] <- quantiles$data[[i]] %>%
      group_by(split) %>%
      mutate(training='test') %>%
      filter(date_extracted > quantile(date_extracted, .7))

    # make the last split the holdout
    quantiles_test$data[[i]][quantiles_test$data[[i]]$split==splits,'training'] <- 'holdout'

  }

  # Don't waste data from test sets, add to next train
  quantiles_train_new <- data.frame()
  quantiles_train_temp <- data.frame()
  for (j in 1:nrow(quantiles_train)){
    for (i in 1:splits){
      if (j == 1){ # if first iteration need to first initialize new objects _temp and _new
        quantiles_train_temp <- quantiles_train
        quantiles_train_new <- quantiles_train_temp

        quantiles_train_temp$data[[j]] <- quantiles_train$data[[j]] %>%
          filter(split == i) %>%
          bind_rows(filter(quantiles_test$data[[j]], split == i-1))

        quantiles_train_new$data[[j]] <- bind_rows(quantiles_train_new$data[[j]], quantiles_train_temp$data[[j]])
      }
      else{
        quantiles_train_temp$data[[j]] <- quantiles_train$data[[j]] %>%
          filter(split == i) %>%
          bind_rows(filter(quantiles_test$data[[j]], split == i-1))

        quantiles_train_new$data[[j]] <- bind_rows(quantiles_train_new$data[[j]], quantiles_train_temp$data[[j]])
      }
    }
  }
  quantiles_train_new <- quantiles_train_new %>% mutate(exchange='HitBTC')


  # Now create new data structure with new columns train and test with 5 splits:
  quantiles_new <- quantiles_train_new
  quantiles_grouped <- quantiles_new
  for (i in 1:nrow(quantiles_train_new)){

    quantiles_new$data[[i]] <- bind_rows(quantiles_train_new$data[[i]], quantiles_test$data[[i]])

    quantiles_grouped$data[[i]] <- quantiles_new$data[[i]] %>% nest(-split, -training) %>% spread(training, data)
  }

  # this version returns the un-nested version so the dates can be visualized easier
  return(quantiles_new)
}
