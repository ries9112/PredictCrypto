#'@importFrom lubridate hours
#'@importFrom dplyr rename
#'@importFrom dplyr select
#'@export
calculate_percent_change_dev <- function(data, hours_later){ #would be better to take name/unique identifier from user too here

  # make pkey for join
  data$pkey <- paste0(data$pk_dummy, data$name)

  # new object for join offset
  data_join <- data

  # adjust by x hours
  data_join$date_time_colorado_mst <- data_join$date_time_colorado_mst + hours(hours_later)

  # make adjusted pk_dummy
  data_join$pk_dummy <- substr(data_join$date_time_colorado_mst, 1, 13)

  # make adjusted pkey
  data_join$pkey <- paste0(data$pk_dummy, data$name)

  # rename new offsetprice_usd field
  data_join <- dplyr::rename(data_join, price_usd_24h_later = 'price_usd') # ADJUST FIELD NAME WITH TIDY EVAL

  # join data and overwrite old object
  data_join <- merge(x=data, y=data_join[, c('pkey', 'price_usd_24h_later')], by = 'pkey', all.x = T)

  # calculate % change target
  for (i in data_join){

    if (data_join[i,]$price_usd_24h_later > data_join[i,]$price_usd){
      data_join[i,]$target_percent_change <- (data_join[i,]$price_usd_24h_later - data_join[i,]$price_usd) / data_join[i,]$price_usd * 100
    }
    else if (data_join[i,]$price_usd_24h_later < data_join[i,]$price_usd){
      data_join[i,]$target_percent_change <- (data_join[i,]$price_usd - data_join[i,]$price_usd_24h_later) / data_join[i,]$price_usd * 100
    }
    else{
      data_join[i,]$target_percent_change <- 0
    }

    return(print(i))


  }
  # remove price_usd_24h_later field to avoid target leak
  data_join <- dplyr::select(data_join, -'price_usd_24h_later')

  # return the end result
  return(data_join)

}

# Note 04/21: Remember to create new tests

