#'@importFrom magrittr  %>%
#'@importFrom dplyr  select
#'@importFrom dplyr  rename
#'@export
crypto_data_join <- function(full_dataset, data_with_prices){
  # rename field
  data_with_prices$exchange_price <- data_with_prices$Price
  # initialize crypto_data
  crypto_data <- data_with_prices
  # add pkey to full_dataset
  full_dataset$pkey <- paste0(full_dataset$pk_dummy, full_dataset$name)
  # add pkey to data_with_prices
  data_with_prices$pkey <- paste0(data_with_prices$pkDummy, data_with_prices$Name)
  # merge the two
  crypto_data <- merge(x = full_dataset, y = data_with_prices[, c("pkey","exchange_price", "Exchange")], by = "pkey", all.x = T)
  # make tweaks to the result
  crypto_data <- crypto_data %>% select(-price_usd) %>% rename(price_usd = "exchange_price", exchange='Exchange') %>% subset(price_usd > 0)
  # return crypto_data
  return(crypto_data)
  # remove empty objects and label these as being from the exchange full_dataset:
  #crypto_data <- crypto_data %>%  mutate(exchange = "full_dataset")
}
