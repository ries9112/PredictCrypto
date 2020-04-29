#'@importFrom magrittr  %>%
#'@importFrom dplyr  select
#'@importFrom dplyr  rename
#'@importFrom dplyr  subset
#'@export
crypto_data_join <- function(full_dataset, data_with_prices){
  # rename field
  full_dataset$exchange_price <- full_dataset$Price
  # initialize crypto_data
  crypto_data <- data_with_prices
  # add pkey to full_dataset
  full_dataset$pkey <- paste0(full_dataset$pkDummy, full_dataset$Name)
  # add pkey to data_with_prices
  data_with_prices$pkey <- paste0(data_with_prices$pk_dummy,
                                           data_with_prices$name)
  # merge the two
  crypto_data <- merge(x = data_with_prices, y = full_dataset[, c("pkey","exchange_price")], by = "pkey", all.x = T)
  # make tweaks to the result
  crypto_data <- crypto_data %>% select(-"price_usd") %>% rename(price_usd = "exchange_price") %>%
    subset(price_usd > 0)  #rename so don't need to adjust formula
  # return crypto_data
  return(crypto_data)
  # remove empty objects and label these as being from the exchange full_dataset:
  #crypto_data <- crypto_data %>%  mutate(exchange = "full_dataset")
}
