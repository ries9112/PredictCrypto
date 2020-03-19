context('Checking that executing calculate_percent_change_daily_version() produces the expected results')

test_that("calculate_percent_change_daily_version works", {
  # create dummy data for test
  crypto_dummy_data <- data.frame(date_time = c('2020-02-01 15:01:32',
                                                '2020-02-02 15:02:14'),
                                  price_usd = c(100,
                                                110),
                                  symbol = 'BTC',
                                  stringsAsFactors = F)

  crypto_dummy_data$date_time <- anytime(crypto_dummy_data$date_time)

  # add target field to check
  crypto_dummy_data <- calculate_percent_change_daily_version(crypto_dummy_data,24,'hours')

  # check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data$target_percent_change, 10)

  ### Validate -% also works and try different hours value ###
  # create dummy data for test
  crypto_dummy_data2 <- data.frame(date_time = c('2020-02-01 15:05:51',
                                                 '2020-02-01 20:01:03'),
                                   price_usd = c(100,
                                                 80),
                                   symbol = 'BTC',
                                   stringsAsFactors = F)

  crypto_dummy_data2$date_time <- anytime(crypto_dummy_data2$date_time)

  # add target field to check
  crypto_dummy_data2 <- calculate_percent_change_daily_version(crypto_dummy_data2,5,'hours')

  # check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data2$target_percent_change, -20)


  ### Validate one more example as an edge case###
  # create dummy data for test
  crypto_dummy_data3 <- data.frame(date_time = c('2020-02-01 15:00:42',
                                                 '2020-02-02 03:02:12'),
                                   price_usd = c(100,
                                                 99.9),
                                   symbol = 'BTC',
                                   stringsAsFactors = F)

  crypto_dummy_data3$date_time <- anytime(crypto_dummy_data3$date_time)

  # add target field to check
  crypto_dummy_data3 <- calculate_percent_change_daily_version(crypto_dummy_data3,12,'hours')

  # check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data3$target_percent_change, -0.1)




  ### Validate one more example as an edge case###
  # create dummy data for test
  crypto_dummy_data4 <- data.frame(date_time = c('2020-02-01 15:05:36',
                                                 '2020-02-03 15:01:27'),
                                   price_usd = c(100,
                                                 1100),
                                   symbol = 'BTC',
                                   stringsAsFactors = F)

  crypto_dummy_data4$date_time <- anytime(crypto_dummy_data4$date_time)

  # add target field to check
  crypto_dummy_data4 <- calculate_percent_change_daily_version(crypto_dummy_data4,2,'days')

  # check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data4$target_percent_change, 1000)


})

