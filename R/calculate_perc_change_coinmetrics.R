#'@importFrom anytime anytime
#'@importFrom lubridate hours
#'@importFrom dplyr left_join
#'@importFrom dplyr select
#'@importFrom dplyr rename
#'@importFrom dplyr filter
#'@export
calculate_perc_change_coinmetrics <- function (coin_metrics, enter_hours)
{
  coin_metrics$date_time_utc <- anytime(coin_metrics$date_time_utc)

  coin_metricsHLater <- coin_metrics

  #create 24h offset
  coin_metricsHLater$date_time_utc <- coin_metricsHLater$date_time_utc - lubridate::hours(enter_hours)

  #replace pkDummy
  coin_metricsHLater$pkDummy <- substr(paste(as.POSIXct(coin_metricsHLater$date_time_utc,format="%Y-%m-%d"), format(as.POSIXct(coin_metricsHLater$date_time_utc,format="%H:%M:%S"),"%H")),1,13)

  coin_metrics$pkDummy <- substr(paste(as.POSIXct(coin_metrics$date_time_utc,format="%Y-%m-%d"), format(as.POSIXct(coin_metrics$date_time_utc,format="%H:%M:%S"),"%H")),1,13)

  coin_metrics$pkey <- paste(coin_metrics$pkDummy, coin_metrics$Name)

  coin_metricsHLater$pkey <- paste(coin_metricsHLater$pkDummy, coin_metricsHLater$Name)

  #re-adjust offset
  coin_metricsHLater$date_time_utc <- coin_metricsHLater$date_time_utc + lubridate::hours(enter_hours)

  coin_metricsHLater <- dplyr::select(coin_metricsHLater, PriceUSD, pkey, date_time_utc) %>%
    #dplyr::rename("PriceUSD_{{ enter_hours }}_hoursLater" = PriceUSD, date_time_utc_x_hoursLater = date_time_utc)
    dplyr::rename(PriceUSD_x_hoursLater = PriceUSD, date_time_utc_x_hoursLater = date_time_utc)

  joinedDataset <- dplyr::left_join(coin_metrics, coin_metricsHLater, by = "pkey")
  #joinedDataset <- filter(joinedDataset, joinedDataset$date_time_utc <=
  #                          max(coin_metrics$date_time_utc) - (24*60*60 )

  joinedDataset$TargetPercChange <- ((as.numeric(joinedDataset$PriceUSD_x_hoursLater) -
                                        as.numeric(joinedDataset$PriceUSD))/as.numeric(joinedDataset$PriceUSD)) * 100

  joinedDataset <- dplyr::select(joinedDataset, -1)

  return(joinedDataset %>% dplyr::filter(!is.na(TargetPercChange)))
  #return(coin_metrics)
}

#### IMPORTANT NOTE FOR CODE ABOVE. RATHER THAN HAVING "XhoursLater", find a way to concat the string of the field name with the user input enterHours! Important, do it before tutorial is too far along!

# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
