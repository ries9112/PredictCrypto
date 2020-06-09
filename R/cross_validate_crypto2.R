#'@importFrom magrittr %>%
#'@importFrom dplyr mutate
#'@importFrom dplyr ntile
#'@importFrom dplyr group_by
#'@export
cross_validate_crypto2 <- function (data, splits = 5)
{
  data <- dplyr::group_by(data, name, exchange)
  split_one <- data[dplyr::ntile(data$date_time_colorado_mst,
                                 10) > 4, ]
  split_one_train <- split_one[dplyr::ntile(split_one$date_time_colorado_mst,
                                            10) <= 8, ] %>% dplyr::mutate(training = "train")
  split_one_test <- split_one[dplyr::ntile(split_one$date_time_colorado_mst,
                                           10) > 8, ] %>% dplyr::mutate(training = "holdout")
  split_one <- dplyr::union(split_one_train, split_one_test)
  rows_per_split <- (nrow(split_one_train) + nrow(split_one_test))/(splits +
                                                                      1)
  split_one_min_datetime <- min(split_one_train$date_time_colorado_mst)
  split_two <- split_one_train
  split_two <- union(dplyr::mutate(tail(data[data$date_time_colorado_mst <
                                               split_one_min_datetime, ], rows_per_split), training = "train"),
                     split_two)
  split_two_test <- split_two[dplyr::ntile(split_two$date_time_colorado_mst,
                                           10) > 8, ] %>% dplyr::mutate(training = "test")
  split_two <- split_two[dplyr::ntile(split_two$date_time_colorado_mst,
                                      10) <= 8, ]
  split_two <- dplyr::union(split_two, split_two_test)
  split_three <- split_two[dplyr::ntile(split_two$date_time_colorado_mst,
                                        10) <= 8, ]
  split_three <- union(dplyr::mutate(tail(data[data$date_time_colorado_mst <
                                                 min(split_two$date_time_colorado_mst), ], rows_per_split),
                                     training = "train"), split_three)
  split_three_test <- split_three[dplyr::ntile(split_three$date_time_colorado_mst,
                                               10) > 8, ] %>% dplyr::mutate(training = "test")
  split_three <- split_three[dplyr::ntile(split_three$date_time_colorado_mst,
                                          10) <= 8, ]
  split_three <- dplyr::union(split_three, split_three_test)
  split_four <- split_three[dplyr::ntile(split_three$date_time_colorado_mst,
                                         10) <= 8, ]
  split_four <- union(dplyr::mutate(tail(data[data$date_time_colorado_mst <
                                                min(split_three$date_time_colorado_mst), ], rows_per_split),
                                    training = "train"), split_four)
  split_four_test <- split_four[dplyr::ntile(split_four$date_time_colorado_mst,
                                             10) > 8, ] %>% dplyr::mutate(training = "test")
  split_four <- split_four[dplyr::ntile(split_four$date_time_colorado_mst,
                                        10) <= 8, ]
  split_four <- dplyr::union(split_four, split_four_test)
  split_five <- split_four[dplyr::ntile(split_four$date_time_colorado_mst,
                                        10) <= 8, ]
  split_five <- union(dplyr::mutate(tail(data[data$date_time_colorado_mst <
                                                min(split_four$date_time_colorado_mst), ], rows_per_split),
                                    training = "train"), split_five)
  split_five_test <- split_five[dplyr::ntile(split_five$date_time_colorado_mst,
                                             10) > 8, ] %>% dplyr::mutate(training = "test")
  split_five <- split_five[dplyr::ntile(split_five$date_time_colorado_mst,
                                        10) <= 8, ]
  split_five <- dplyr::union(split_five, split_five_test)
  split_one$split <- 1
  split_two$split <- 2
  split_three$split <- 3
  split_four$split <- 4
  split_five$split <- 5
  finalized_data <- dplyr::union(split_one, split_two) %>%
    dplyr::union(split_three) %>% dplyr::union(split_four) %>%
    dplyr::union(split_five)
  return(finalized_data)
}
