#'@importFrom lubridate hours
#'@importFrom dplyr rename
#'@importFrom anytime anytime
#'@importFrom lubridate hours
#'@importFrom dplyr left_join
#'@importFrom dplyr select
#'@importFrom dplyr rename
#'@importFrom dplyr filter
#'@importFrom dplyr distinct
#'@importFrom magrittr %>%
#'@export
calculate_percent_change_new <- function (crypto_dataset, units_offset, units = c("hours", "days"))
{
  crypto_dataset$date_time_utc <- anytime(crypto_dataset$date_time_utc)

  if (units == "hours") {
    crypto_datasetHLater <- crypto_dataset
    crypto_datasetHLater$date_time_utc <- crypto_datasetHLater$date_time_utc -
      lubridate::hours(units_offset)
    crypto_datasetHLater$pk_dummy <- substr(paste(as.POSIXct(crypto_datasetHLater$date_time_utc,
                                                             format = "%Y-%m-%d"), format(as.POSIXct(crypto_datasetHLater$date_time_utc,
                                                                                                     format = "%H:%M:%S"), "%H")), 1, 13)
    crypto_dataset$pk_dummy <- substr(paste(as.POSIXct(crypto_dataset$date_time_utc,
                                                       format = "%Y-%m-%d"), format(as.POSIXct(crypto_dataset$date_time_utc,
                                                                                               format = "%H:%M:%S"), "%H")), 1, 13)
    crypto_dataset$pkey <- paste(crypto_dataset$pk_dummy,
                                 crypto_dataset$name)
    crypto_datasetHLater$pkey <- paste(crypto_datasetHLater$pk_dummy,
                                       crypto_datasetHLater$name)
    crypto_datasetHLater$date_time_utc <- crypto_datasetHLater$date_time_utc +
      lubridate::hours(units_offset)
    crypto_datasetHLater <- dplyr::select(crypto_datasetHLater,
                                          price_usd, pkey, date_time_utc) %>% dplyr::rename(price_usd_x_hoursLater = price_usd,
                                                                                        date_time_utc_x_hoursLater = date_time_utc)
    joinedDataset <- dplyr::left_join(crypto_dataset, crypto_datasetHLater,
                                      by = "pkey")
    joinedDataset <- joinedDataset %>% dplyr::distinct(pkey,
                                                       .keep_all = TRUE)
    joinedDataset$target_percent_change <- ((joinedDataset$price_usd_x_hoursLater -
                                               joinedDataset$price_usd)/joinedDataset$price_usd) *
      100
    joinedDataset <- dplyr::select(joinedDataset, -price_usd_x_hoursLater,
                                   -date_time_utc_x_hoursLater)
    return(joinedDataset %>% dplyr::filter(!is.na(target_percent_change)))
  }
  else if (units == "days") {
    crypto_datasetHLater <- crypto_dataset
    crypto_datasetHLater$date_time_utc <- crypto_datasetHLater$date_time_utc -
      lubridate::days(units_offset)
    crypto_datasetHLater$pk_dummy <- substr(paste(as.POSIXct(crypto_datasetHLater$date_time_utc,
                                                             format = "%Y-%m-%d"), format(as.POSIXct(crypto_datasetHLater$date_time_utc,
                                                                                                     format = "%H:%M:%S"), "%H")), 1, 13)
    crypto_dataset$pk_dummy <- substr(paste(as.POSIXct(crypto_dataset$date_time_utc,
                                                       format = "%Y-%m-%d"), format(as.POSIXct(crypto_dataset$date_time_utc,
                                                                                               format = "%H:%M:%S"), "%H")), 1, 13)
    crypto_dataset$pkey <- paste(crypto_dataset$pk_dummy,
                                 crypto_dataset$name)
    crypto_datasetHLater$pkey <- paste(crypto_datasetHLater$pk_dummy,
                                       crypto_datasetHLater$name)
    crypto_datasetHLater$date_time_utc <- crypto_datasetHLater$date_time_utc +
      lubridate::days(units_offset)
    crypto_datasetHLater <- dplyr::select(crypto_datasetHLater,
                                          price_usd, pkey, date_time_utc) %>% dplyr::rename(price_usd_x_daysLater = price_usd,
                                                                                        date_time_utc_x_daysLater = date_time_utc)
    joinedDataset <- dplyr::left_join(crypto_dataset, crypto_datasetHLater,
                                      by = "pkey")
    joinedDataset <- joinedDataset %>% dplyr::distinct(pkey,
                                                       .keep_all = TRUE)
    joinedDataset$target_percent_change <- ((joinedDataset$price_usd_x_daysLater -
                                               joinedDataset$price_usd)/joinedDataset$price_usd) *
      100
    joinedDataset <- dplyr::select(joinedDataset, -price_usd_x_daysLater,
                                   -date_time_utc_x_daysLater)
    return(joinedDataset %>% dplyr::filter(!is.na(target_percent_change)))
  }
}

#### IMPORTANT NOTE FOR CODE ABOVE. RATHER THAN HAVING "XhoursLater", find a way to concat the string of the field symbol with the user input units_offset! Important, do it before tutorial is too far along!

# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
