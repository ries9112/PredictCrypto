library(testthat)
library(PredictCrypto)
library(anytime)

# pull data for checks
get_crypto_data()

test_check("PredictCrypto")
