#'@importFrom magrittr %>%
#'@importFrom dplyr arrange
#'@importFrom dplyr mutate
#'@importFrom dplyr ntile
#'@importFrom dplyr group_by
#'@importFrom dplyr filter
#'@importFrom dplyr bind_rows
#'@export
cross_validate_crypto_5 <- function (data) {
  # This version is meant for 5 cv folds only
  folds = 5
  #Setup for loop
  # Turn number of folds into a percentage. 5 = 50% (each fold uses this much of total data)
  folds_percentile = 1-(folds/10)

  # initialize new data
  all_data <- data
  complete_data <- data
  new_data <- data
  new_data_grouped <- data

  # Start for loop
  for (i in 1:nrow(data)){


    # # All folds at once:
    #   for (j in 1:folds){
    #     # initialize fold data
    #     fold_data <- data
    #     # adjust fold data
    #     fold_data$data[[i]] <- all_data$data[[i]][all_data$data[[i]]$date_time_colorado_mst >= toString(quantile(all_data$data[[i]]$date_time_colorado_mst, folds_percentile)),]
    #     # Set current split/fold:
    #     fold_data$data[[i]]$split <- j
    #     # initialize training column
    #     fold_data$data[[i]]$training <-
    #     # add training labels
    #     fold_data$data[[i]][fold_data$data[[i]]$date_time_colorado_mst < toString(quantile(fold_data$data[[i]]$date_time_colorado_mst, 0.7)),]$training <- 'train'
    #     # same for test
    #     fold_data$data[[i]][fold_data$data[[i]]$date_time_colorado_mst >= toString(quantile(fold_data$data[[i]]$date_time_colorado_mst, 0.7)),]$training <- 'test'
    #     # Remove the 30% that went to test from the total data
    #     all_data$data[[i]] <- all_data$data[[i]][all_data$data[[i]]$date_time_colorado_mst < min(all_data$data[[i]]$date_time_colorado_mst),]
    #
    #     # New data
    #     new_data$data[[i]] <- bind_rows(fold_data_test$data[[i]], fold_data_test$data[[i]])
    #
    #   }
    #
    #   # Nest new data
    #   new_data$data[[i]] <- new_data$data[[i]] %>% nest(-split, -training) %>% spread(training, data)
    #
    #   print(i)
    # }

    # One at a time:
    #print(i)
    # Use % (50%) to take most recent % of all data
    all_data <- data$data[[i]]
    fold1_data <- all_data[all_data$date_time_colorado_mst >= toString(quantile(all_data$date_time_colorado_mst, folds_percentile)),]
    # Create train/test split 70/30 for current data
    fold1_data_train <- fold1_data[fold1_data$date_time_colorado_mst < toString(quantile(fold1_data$date_time_colorado_mst, 0.7)),]
    fold1_data_train$training <- 'train'
    fold1_data_train$split <- 1
    # same for test
    fold1_data_test <- fold1_data[fold1_data$date_time_colorado_mst >= toString(quantile(fold1_data$date_time_colorado_mst, 0.7)),]
    fold1_data_test$training <- 'holdout'
    fold1_data_test$split <- 1
    # Remove the 30% that went to test from the total data
    all_data <- complete_data$data[[i]][complete_data$data[[i]]$date_time_colorado_mst < min(fold1_data_test$date_time_colorado_mst),]
    print(i)
    # Take new most recent 50% of all data
    fold2_data <- all_data[all_data$date_time_colorado_mst >= toString(quantile(all_data$date_time_colorado_mst, folds_percentile)),]
    # Create train/test split 70/30 for current data
    fold2_data_train <- fold2_data[fold2_data$date_time_colorado_mst < toString(quantile(fold2_data$date_time_colorado_mst, 0.7)),]
    fold2_data_train$training <- 'train'
    fold2_data_train$split <- 2
    # same for test
    fold2_data_test <- fold2_data[fold2_data$date_time_colorado_mst >= toString(quantile(fold2_data$date_time_colorado_mst, 0.7)),]
    fold2_data_test$training <- 'test'
    fold2_data_test$split <- 2
    # Remove the 30% that went to test from the total data
    all_data <- complete_data$data[[i]][complete_data$data[[i]]$date_time_colorado_mst < min(fold2_data_test$date_time_colorado_mst),]
    # third fold:
    # Take new most recent 50% of all data
    fold3_data <- all_data[all_data$date_time_colorado_mst >= toString(quantile(all_data$date_time_colorado_mst, folds_percentile)),]
    # Create train/test split 70/30 for current data
    fold3_data_train <- fold3_data[fold3_data$date_time_colorado_mst < toString(quantile(fold3_data$date_time_colorado_mst, 0.7)),]
    fold3_data_train$training <- 'train'
    fold3_data_train$split <- 3
    # same for test
    fold3_data_test <- fold3_data[fold3_data$date_time_colorado_mst >= toString(quantile(fold3_data$date_time_colorado_mst, 0.7)),]
    fold3_data_test$training <- 'test'
    fold3_data_test$split <- 3
    # Remove the 30% that went to test from the total data
    all_data <- complete_data$data[[i]][complete_data$data[[i]]$date_time_colorado_mst < min(fold3_data_test$date_time_colorado_mst),]

    # fourth fold:
    # Take new most recent 50% of all data
    fold4_data <- all_data[all_data$date_time_colorado_mst >= toString(quantile(all_data$date_time_colorado_mst, folds_percentile)),]
    # Create train/test split 70/30 for current data
    fold4_data_train <- fold4_data[fold4_data$date_time_colorado_mst < toString(quantile(fold4_data$date_time_colorado_mst, 0.7)),]
    fold4_data_train$training <- 'train'
    fold4_data_train$split <- 4
    # same for test
    fold4_data_test <- fold4_data[fold4_data$date_time_colorado_mst >= toString(quantile(fold4_data$date_time_colorado_mst, 0.7)),]
    fold4_data_test$training <- 'test'
    fold4_data_test$split <- 4
    # Remove the 30% that went to test from the total data
    all_data <- complete_data$data[[i]][complete_data$data[[i]]$date_time_colorado_mst < min(fold4_data_test$date_time_colorado_mst),]

    # Fifth fold:
    # Take new most recent 50% of all data
    fold5_data <- all_data[all_data$date_time_colorado_mst >= toString(quantile(all_data$date_time_colorado_mst, folds_percentile)),]
    # Create train/test split 70/30 for current data
    fold5_data_train <- fold5_data[fold5_data$date_time_colorado_mst < toString(quantile(fold5_data$date_time_colorado_mst, 0.7)),]
    fold5_data_train$training <- 'train'
    fold5_data_train$split <- 5
    # same for test
    fold5_data_test <- fold5_data[fold5_data$date_time_colorado_mst >= toString(quantile(fold5_data$date_time_colorado_mst, 0.7)),]
    fold5_data_test$training <- 'test'
    fold5_data_test$split <- 5
    # Remove the 30% that went to test from the total data
    all_data <- complete_data$data[[i]][complete_data$data[[i]]$date_time_colorado_mst < min(fold5_data_test$date_time_colorado_mst),]

    # new data
    new_data$data[[i]] <- rbind(fold1_data_train, fold1_data_test, fold2_data_train, fold2_data_test,
                                fold3_data_train, fold3_data_test, fold4_data_train, fold4_data_test, fold5_data_train, fold5_data_test)
    # group data
    new_data_grouped$data[[i]] <- new_data$data[[i]] %>% nest(-split, -training) %>% spread(training, data)

  }

  cross_validate_show_dates <<- new_data
  return(new_data_grouped)
}



