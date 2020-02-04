#'@importFrom anytime anytime
#'@importFrom lubridate hours
#'@importFrom dplyr left_join
#'@importFrom dplyr select
#'@importFrom dplyr rename
#'@importFrom dplyr filter
#'@export
calculate_perc_change <- function (df, enterHours)
{
  dfHLater <- cryptoData

  #create 24h offset
  dfHLater$DateTimeColoradoTimeMST <- dfHLater$DateTimeColoradoTimeMST - lubridate::hours(enterHours)

  #replace pkDummy
  dfHLater$pkDummy <- substr(paste(as.POSIXct(dfHLater$DateTimeColoradoTimeMST,format="%Y-%m-%d"), format(as.POSIXct(dfHLater$DateTimeColoradoTimeMST,format="%H:%M:%S"),"%H")),1,13)

  cryptoData$pkDummy <- substr(paste(as.POSIXct(cryptoData$DateTimeColoradoTimeMST,format="%Y-%m-%d"), format(as.POSIXct(cryptoData$DateTimeColoradoTimeMST,format="%H:%M:%S"),"%H")),1,13)

  cryptoData$pkey <- paste(cryptoData$pkDummy, cryptoData$Name)

  dfHLater$pkey <- paste(dfHLater$pkDummy, dfHLater$Name)

  #re-adjust offset
  dfHLater$DateTimeColoradoTimeMST <- dfHLater$DateTimeColoradoTimeMST + lubridate::hours(enterHours)

  dfHLater <- dplyr::select(dfHLater, PriceUSD, pkey, DateTimeColoradoTimeMST) %>%
    dplyr::rename(PriceUSD_x_hoursLater = PriceUSD, DateTimeColoradoTimeMST_x_hoursLater = DateTimeColoradoTimeMST)

  joinedDataset <- dplyr::left_join(cryptoData, dfHLater, by = "pkey")
  #joinedDataset <- filter(joinedDataset, joinedDataset$DateTimeColoradoTimeMST <=
  #                          max(cryptoData$DateTimeColoradoTimeMST) - (24*60*60 )

  joinedDataset$TargetPercChange <- ((joinedDataset$PriceUSD_x_hoursLater -
                                        joinedDataset$PriceUSD)/joinedDataset$PriceUSD) * 100

  joinedDataset <- dplyr::select(joinedDataset, -1)

  cryptoData <<- joinedDataset %>% dplyr::filter(!is.na(TargetPercChange))
  #return(cryptoData)
}

#### IMPORTANT NOTE FOR CODE ABOVE. RATHER THAN HAVING "XhoursLater", find a way to concat the string of the field name with the user input enterHours! Important, do it before tutorial is too far along!

# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
