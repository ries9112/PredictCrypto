#'@importFrom anytime anytime
#'@importFrom lubridate hours
#'@importFrom dplyr left_join
#'@importFrom dplyr select
#'@importFrom dplyr rename
#'@importFrom dplyr filter
#'@importFrom dplyr distinct
#'@importFrom magrittr %>%
#'@export
calculate_percent_change_second_version <- function (crypto_dataset, price_field, date_time_field, units_offset, units=c('hours','days'))
{
  price_field <- enquo(price_field)
  date_time_field <- enquo(date_time_field)

  # function demands the fields: "symbol", "price_usd" and "!!" to work!
  # Ideally make the user point these out directly using tidyeval

  # Join also works only at the hourly level

  # Make all documentation!

  # TO FIX ERROR NEED TO CHANGE EVERYTHING TO TIDY NOTATION!

  #crypto_dataset %>% select(!!date_time_field) <- anytime(crypto_dataset %>% select(!!date_time_field))

  if (units == 'hours'){

    crypto_datasetHLater <- crypto_dataset

    #create 24h offset
    crypto_datasetHLater %>% select(!!date_time_field) <- crypto_datasetHLater %>% select(!!date_time_field) - lubridate::hours(units_offset)

    #replace pkDummy
    crypto_datasetHLater$pkDummy <- substr(paste(as.POSIXct(crypto_datasetHLater %>% select(!!date_time_field),format="%Y-%m-%d"), format(as.POSIXct(crypto_datasetHLater %>% select(!!date_time_field),format="%H:%M:%S"),"%H")),1,13)

    crypto_dataset$pkDummy <- substr(paste(as.POSIXct(crypto_dataset %>% select(!!date_time_field),format="%Y-%m-%d"), format(as.POSIXct(crypto_dataset %>% select(!!date_time_field),format="%H:%M:%S"),"%H")),1,13)

    crypto_dataset$pkey <- paste(crypto_dataset$pkDummy, crypto_dataset$symbol)

    crypto_datasetHLater$pkey <- paste(crypto_datasetHLater$pkDummy, crypto_datasetHLater$symbol)

    #re-adjust offset
    crypto_datasetHLater %>% select(!!date_time_field) <- crypto_datasetHLater %>% select(!!date_time_field) + lubridate::hours(units_offset)

    crypto_datasetHLater <- dplyr::select(crypto_datasetHLater, !!price_field, pkey, !!date_time_field) %>%
      dplyr::rename(price_usd_x_hoursLater = !!price_field, date_time_x_hoursLater = !!date_time_field)

    joinedDataset <- dplyr::left_join(crypto_dataset, crypto_datasetHLater, by = "pkey")
    #joinedDataset <- filter(joinedDataset, joinedDataset$!! <=
    #                          max(crypto_dataset$!!) - (24*60*60 )
    joinedDataset <- joinedDataset %>% dplyr::distinct(pkey, .keep_all = TRUE)

    joinedDataset$target_percent_change <- ((joinedDataset$price_usd_x_hoursLater -
                                               joinedDataset %>% select(!!price_field))/joinedDataset %>% select(!!price_field)) * 100

    joinedDataset <- dplyr::select(joinedDataset, -price_usd_x_hoursLater, -date_time_x_hoursLater)

    return(joinedDataset %>% dplyr::filter(!is.na(target_percent_change)))
    #return(crypto_dataset)

  }


  else if (units == 'days'){

    crypto_datasetHLater <- crypto_dataset

    #create 24h offset
    crypto_datasetHLater %>% select(!!date_time_field) <- crypto_datasetHLater %>% select(!!date_time_field) - lubridate::days(units_offset)

    #replace pkDummy
    crypto_datasetHLater$pkDummy <- substr(paste(as.POSIXct(crypto_datasetHLater %>% select(!!date_time_field),format="%Y-%m-%d"), format(as.POSIXct(crypto_datasetHLater %>% select(!!date_time_field),format="%H:%M:%S"),"%H")),1,13)

    crypto_dataset$pkDummy <- substr(paste(as.POSIXct(crypto_dataset %>% select(!!date_time_field),format="%Y-%m-%d"), format(as.POSIXct(crypto_dataset %>% select(!!date_time_field),format="%H:%M:%S"),"%H")),1,13)

    crypto_dataset$pkey <- paste(crypto_dataset$pkDummy, crypto_dataset$symbol)

    crypto_datasetHLater$pkey <- paste(crypto_datasetHLater$pkDummy, crypto_datasetHLater$symbol)

    #re-adjust offset
    crypto_datasetHLater %>% select(!!date_time_field) <- crypto_datasetHLater %>% select(!!date_time_field) + lubridate::days(units_offset)

    crypto_datasetHLater <- dplyr::select(crypto_datasetHLater, !!price_field, pkey, !!date_time_field) %>%
      dplyr::rename(price_usd_x_daysLater = !!price_field, date_time_x_daysLater = !!date_time_field)

    joinedDataset <- dplyr::left_join(crypto_dataset, crypto_datasetHLater, by = "pkey")
    #joinedDataset <- filter(joinedDataset, joinedDataset$!! <=
    #                          max(crypto_dataset$!!) - (24*60*60 )

    joinedDataset <- joinedDataset %>% dplyr::distinct(pkey, .keep_all = TRUE)

    joinedDataset$target_percent_change <- ((joinedDataset$price_usd_x_daysLater -
                                               joinedDataset %>% select(!!price_field))/joinedDataset %>% select(!!price_field)) * 100

    joinedDataset <- dplyr::select(joinedDataset, -price_usd_x_daysLater, -date_time_x_daysLater)

    return(joinedDataset %>% dplyr::filter(!is.na(target_percent_change)))
    #return(crypto_dataset)

  }



}

#### IMPORTANT NOTE FOR CODE ABOVE. RATHER THAN HAVING "XhoursLater", find a way to concat the string of the field symbol with the user input units_offset! Important, do it before tutorial is too far along!

# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
