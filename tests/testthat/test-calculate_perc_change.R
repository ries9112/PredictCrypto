context('Checking that executing calculate_perc_change() produces the expected results')

test_that("calculate_perc_change works", {
# create dummy data for test
  crypto_dummy_data <- data.frame(DateTimeColoradoTimeMST = c('2020-02-01 15:00',
                                                              '2020-02-02 15:00'),
                                  PriceUSD = c(100,
                                               110),
                                  stringsAsFactors = F)

  crypto_dummy_data$DateTimeColoradoTimeMST <- anytime(crypto_dummy_data$DateTimeColoradoTimeMST)

# add target field to check
  crypto_dummy_data <- calculate_perc_change(crypto_dummy_data,24)

# check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data$TargetPercChange, 10)

### Validate -% also works and try different hours value ###
  # create dummy data for test
  crypto_dummy_data2 <- data.frame(DateTimeColoradoTimeMST = c('2020-02-01 15:00',
                                                              '2020-02-01 20:00'),
                                  PriceUSD = c(100,
                                               80),
                                  stringsAsFactors = F)

  crypto_dummy_data2$DateTimeColoradoTimeMST <- anytime(crypto_dummy_data2$DateTimeColoradoTimeMST)

  # add target field to check
  crypto_dummy_data2 <- calculate_perc_change(crypto_dummy_data2,5)

  # check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data2$TargetPercChange, -20)


### Validate one more example as an edge case###
  # create dummy data for test
  crypto_dummy_data3 <- data.frame(DateTimeColoradoTimeMST = c('2020-02-01 15:00',
                                                               '2020-02-02 03:00'),
                                   PriceUSD = c(100,
                                                99.9),
                                   stringsAsFactors = F)

  crypto_dummy_data3$DateTimeColoradoTimeMST <- anytime(crypto_dummy_data3$DateTimeColoradoTimeMST)

  # add target field to check
  crypto_dummy_data3 <- calculate_perc_change(crypto_dummy_data3,12)

  # check for expected result after running dummy data through my function
  expect_equal(crypto_dummy_data3$TargetPercChange, -0.1)
})

# On 02/11/2020 all tests pass
