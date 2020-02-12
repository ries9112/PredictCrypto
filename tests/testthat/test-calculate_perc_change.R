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
})
