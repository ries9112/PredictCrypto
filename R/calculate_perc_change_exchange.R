#'@importFrom anytime anytime
#'@importFrom lubridate hours
#'@importFrom dplyr left_join
#'@importFrom dplyr select
#'@importFrom dplyr rename
#'@importFrom dplyr filter
#'@export
calculate_perc_change_exchange <- function (crypto_dataset, enterHours)
{
  crypto_datasetHLater <- crypto_dataset

  #create 24h offset
  crypto_datasetHLater$DateTimeColoradoTimeMST <- crypto_datasetHLater$DateTimeColoradoTimeMST - lubridate::hours(enterHours)

  #replace pkDummy
  crypto_datasetHLater$pkDummy <- substr(paste(as.POSIXct(crypto_datasetHLater$DateTimeColoradoTimeMST,format="%Y-%m-%d"), format(as.POSIXct(crypto_datasetHLater$DateTimeColoradoTimeMST,format="%H:%M:%S"),"%H")),1,13)

  crypto_dataset$pkDummy <- substr(paste(as.POSIXct(crypto_dataset$DateTimeColoradoTimeMST,format="%Y-%m-%d"), format(as.POSIXct(crypto_dataset$DateTimeColoradoTimeMST,format="%H:%M:%S"),"%H")),1,13)

  crypto_dataset$pkey <- paste(crypto_dataset$pkDummy, crypto_dataset$Name)

  crypto_datasetHLater$pkey <- paste(crypto_datasetHLater$pkDummy, crypto_datasetHLater$Name)

  #re-adjust offset
  crypto_datasetHLater$DateTimeColoradoTimeMST <- crypto_datasetHLater$DateTimeColoradoTimeMST + lubridate::hours(enterHours)

  crypto_datasetHLater <- dplyr::select(crypto_datasetHLater, PriceUSD, pkey, DateTimeColoradoTimeMST, Exchange) %>%
    dplyr::rename(PriceUSD_x_hoursLater = PriceUSD, DateTimeColoradoTimeMST_x_hoursLater = DateTimeColoradoTimeMST)

  joinedDataset <- dplyr::left_join(crypto_dataset, crypto_datasetHLater, by = c("pkey" = "pkey" , 'Exchange' = 'Exchange'))
  #joinedDataset <- filter(joinedDataset, joinedDataset$DateTimeColoradoTimeMST <=
  #                          max(crypto_dataset$DateTimeColoradoTimeMST) - (24*60*60 )

  joinedDataset$TargetPercChange <- ((joinedDataset$PriceUSD_x_hoursLater -
                                        joinedDataset$PriceUSD)/joinedDataset$PriceUSD) * 100

  joinedDataset <- dplyr::select(joinedDataset, -1)

  return(joinedDataset %>% dplyr::filter(!is.na(TargetPercChange)) )
  #return(crypto_dataset)
}

#### IMPORTANT NOTE FOR CODE ABOVE. RATHER THAN HAVING "XhoursLater", find a way to concat the string of the field name with the user input enterHours! Important, do it before tutorial is too far along!

# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
