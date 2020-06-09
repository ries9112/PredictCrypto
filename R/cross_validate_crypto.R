#'@importFrom magrittr %>%
#'@importFrom dplyr mutate
#'@importFrom dplyr ntile
cross_validate_crypto <- function(data, splits = 5) {
  # for the first split, start by taking most recent 60% of the data
  split_one <- data[dplyr::ntile(data$date_time_colorado_mst, 10) > 4,]
  # still first split, take 80/20 split for train and test
  split_one_train <- split_one[dplyr::ntile(split_one$date_time_colorado_mst, 10) <= 8,] %>% dplyr::mutate(training='train')
  # now test
  split_one_test <- split_one[dplyr::ntile(split_one$date_time_colorado_mst, 10) > 8,] %>% dplyr::mutate(training='holdout')
  # union the two to create split_one again
  split_one <- dplyr::union(split_one_train, split_one_test)
  # for the remaining 40% of the data, find the number of rows to add to the tail end each time
  rows_per_split <- (nrow(split_one_train) + nrow(split_one_test)) / (splits+1)
  # record the current minimum date/time to use it as a starting point for the next split
  split_one_min_datetime <- min(split_one_train$date_time_colorado_mst)

  # start working on the second split.
  # start by taking train from first split (which naturally excludes test)
  split_two <- split_one_train
  # now add number of rows determined earlier
  split_two <- union(dplyr::mutate(head(data[data$date_time_colorado_mst < split_one_min_datetime,], rows_per_split), training='train'), split_two)
  # now make the latest 20% into test
  split_two_test <- split_two[dplyr::ntile(split_two$date_time_colorado_mst, 10) > 8,] %>% dplyr::mutate(training='test')
  # remove latest 20% of data
  split_two <- split_two[dplyr::ntile(split_two$date_time_colorado_mst, 10) <= 8,]
  # union back in
  split_two <- dplyr::union(split_two, split_two_test)

  # now third split
  split_three <- split_two[dplyr::ntile(split_two$date_time_colorado_mst, 10) <= 8,]
  # now add number of rows determined earlier
  split_three <- union(dplyr::mutate(head(data[data$date_time_colorado_mst < min(split_two$date_time_colorado_mst),], rows_per_split), training='train'), split_three)
  # now make the latest 20% into test
  split_three_test <- split_three[dplyr::ntile(split_three$date_time_colorado_mst, 10) > 8,] %>% dplyr::mutate(training='test')
  # remove latest 20% of data
  split_three <- split_three[dplyr::ntile(split_three$date_time_colorado_mst, 10) <= 8,]
  # union back in
  split_three <- dplyr::union(split_three, split_three_test)

  # now fourth split
  split_four <- split_three[dplyr::ntile(split_three$date_time_colorado_mst, 10) <= 8,]
  # now add number of rows determined earlier
  split_four <- union(dplyr::mutate(head(data[data$date_time_colorado_mst < min(split_three$date_time_colorado_mst),], rows_per_split), training='train'), split_four)
  # now make the latest 20% into test
  split_four_test <- split_four[dplyr::ntile(split_four$date_time_colorado_mst, 10) > 8,] %>% dplyr::mutate(training='test')
  # remove latest 20% of data
  split_four <- split_four[dplyr::ntile(split_four$date_time_colorado_mst, 10) <= 8,]
  # union back in
  split_four <- dplyr::union(split_four, split_four_test)

  # now fifth split
  split_five <- split_four[dplyr::ntile(split_four$date_time_colorado_mst, 10) <= 8,]
  # now add number of rows determined earlier
  split_five <- union(dplyr::mutate(head(data[data$date_time_colorado_mst < min(split_four$date_time_colorado_mst),], rows_per_split), training='train'), split_five)
  # now make the latest 20% into test
  split_five_test <- split_five[dplyr::ntile(split_five$date_time_colorado_mst, 10) > 8,] %>% dplyr::mutate(training='test')
  # remove latest 20% of data
  split_five <- split_five[dplyr::ntile(split_five$date_time_colorado_mst, 10) <= 8,]
  # union back in
  split_five <- dplyr::union(split_five, split_five_test)


  # specify splits as columns
  split_one$split <- 1
  split_two$split <- 2
  split_three$split <- 3
  split_four$split <- 4
  split_five$split <- 5

  # at the end, union all
  finalized_data <- dplyr::union(split_one, split_two) %>%
    dplyr::union(split_three) %>%
    dplyr::union(split_four) %>%
    dplyr::union(split_five)
}

#NOTES: STILL HARDCODED FOR 5 FOLDS!


