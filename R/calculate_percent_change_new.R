#'@importFrom lubridate hours
#'@importFrom dplyr rename
#'@importFrom dplyr distinct
#'@importFrom dplyr mutate
#'@importFrom dplyr select
#'@export
calculate_percent_change_new <- function(data, hours_later){ #would be better to take name/unique identifier from user too here

  # make pkey for join
  data$pkey <- paste0(data$pkDummy, data$name)

  # new object for join offset
  data_join <- data

  # adjust by x hours
  data_join$date_time_utc <- data_join$date_time_utc - lubridate::hours(hours_later)

  # make adjusted pkDummy
  data_join$pkDummy <- substr(data_join$date_time_utc, 1, 13)

  # make adjusted pkey
  data_join$pkey <- paste0(data_join$pkDummy, data_join$name)

  # rename new offset price_usd field (only sell price needed)
  data_join <- rename(data_join, sell_price_usd_24h_later = 'sell_price_high_bid') # ADJUST FIELD NAME WITH TIDY EVAL

  # join data and overwrite old object
  data_join <- merge(x=data, y=data_join[, c('pkey', 'sell_price_usd_24h_later')], by = 'pkey', all.x = T)

  # remove rows without target
  data_join <- data_join[complete.cases(data_join[,'sell_price_usd_24h_later']),]

  # calculate % change
  data_join <- mutate(data_join, perc_change_24h_sell_price = ((sell_price_usd_24h_later - sell_price_high_bid)/sell_price_high_bid)*100)

  # Remove sell_price_usd_24h_later
  data_join <- select(data_join, -sell_price_usd_24h_later)

  # adjust pkey by exchange
  data_join$pkey <- paste0(data_join$pkey, data_join$exchange)

  # unique data and return the result
  return(dplyr::distinct(data_join, pkey, .keep_all = T))
}
# Note 04/21: Remember to create new tests
