#'@importFrom PredictCrypto calculate_price_change
#'@export
calculate_price_change_rowwise <- function(crypto_data, hours){ #would be better to take name/unique identifier from user too here
  for (i in length(crypto_data)){
    crypto_data$data[[i]] <- PredictCrypto::calculate_price_change(crypto_data$data[[i]], hours)
  }

}
