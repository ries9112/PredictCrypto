#'@importFrom anytime anytime
#'@importFrom lubridate hours
#'@export
calculate_perc_change <- function(dfHLater, enterHours){
  # FIX THIS, ISSUE WHEN SUBTRACTING HOURS, NOT WORKING NOW???

  dfHLater <- as.data.frame(dfHLater)
  #dfHLater$DateTimeColoradoMST <- anytime::anytime(dfHLater$DateTimeColoradoMST)
  #exclude most recent 12 hours since they wouldn't have data
  #df12hLater_new <- filter(dfHLater, DateTimeColoradoMST <= max(df$DateTimeColoradoMST) - hours(12) )
  dfHLater$DateTimeColoradoMST <- dfHLater$DateTimeColoradoMST - (enterHours * 60 * 60)
  #Replace pkDummy
  dfHLater$pkDummy <-substr(dfHLater$DateTimeColoradoMST, 1, 13)
  df$pkDummy <-substr(df$DateTimeColoradoMST, 1, 13)
  #Create both pkeys
  df$pkey <- paste0(df$pkDummy,df$Name)
  dfHLater$pkey <- paste0(dfHLater$pkDummy,dfHLater$Name)
  #Re-adjust the 12hLater time
  dfHLater$DateTimeColoradoMST <- dfHLater$DateTimeColoradoMST + hours(enterHours)
  #narrow down new dataframe to just the Price
  dfHLater <- select(dfHLater, PriceUSD, pkey, DateTimeColoradoMST) %>% rename(PriceUSD_XhoursLater = PriceUSD, DateTimeColoradoMST_XhoursLater = DateTimeColoradoMST)
  #join data
  joinedDataset <- left_join(df, dfHLater, by='pkey')
  joinedDataset <- filter(joinedDataset, DateTimeColoradoMST <= max(df$DateTimeColoradoMST) - hours(enterHours) )
  #Now calculate % change
  joinedDataset$TargetPercChange <- ((joinedDataset$PriceUSD_XhoursLater-joinedDataset$PriceUSD) / joinedDataset$PriceUSD) * 100
  #Remove first column of the data "X"
  joinedDataset <- select(joinedDataset,-1)

  #colnames(joinedDataset)[colnames(joinedDataset)=="PriceUSD_XhoursLater"] <- paste0('PriceUSD_',enterHours,'_hours_later')

  return(joinedDataset)
}

#### IMPORTANT NOTE FOR CODE ABOVE. RATHER THAN HAVING "XhoursLater", find a way to concat the string of the field name with the user input enterHours! Important, do it before tutorial is too far along!




# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
