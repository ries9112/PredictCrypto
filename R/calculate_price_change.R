#'@importFrom lubridate hours
#'@importFrom dplyr rename
#'@importFrom dplyr distinct
#'@export
calculate_price_change <- function(data, hours_later){ #would be better to take name/unique identifier from user too here

  # make pkey for join
  data$pkey <- paste0(data$pk_dummy, data$name)

  # new object for join offset
  data_join <- data

  # adjust by x hours
  data_join$date_time_colorado_mst <- data_join$date_time_colorado_mst + lubridate::hours(hours_later)

  # make adjusted pk_dummy
  data_join$pk_dummy <- substr(data_join$date_time_colorado_mst, 1, 13)

  # make adjusted pkey
  data_join$pkey <- paste0(data_join$pk_dummy, data_join$name)

  # rename new offsetprice_usd field
  data_join <- rename(data_join, price_usd_24h_later = 'price_usd') # ADJUST FIELD NAME WITH TIDY EVAL

  # join data and overwrite old object
  data_join <- merge(x=data, y=data_join[, c('pkey', 'price_usd_24h_later')], by = 'pkey', all.x = T)

  # unique data and return the result
  return(dplyr::distinct(data_join, pkey, .keep_all = T))
}

# Note 04/21: Remember to create new tests

