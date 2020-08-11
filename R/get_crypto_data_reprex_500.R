#'@importFrom pins board_register
#'@importFrom pins pin_get
#'@importFrom janitor clean_names
#'@importFrom anytime anytime
#'@export
get_crypto_data_reprex_500 <- function(){

  # register pins board
  pins::board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/",'reprex_bitgur_500')
  # convert names to snake_case
  reprex_data <- janitor::clean_names(pins::pin_get('reprex_bitgur_500','reprex_bitgur_500'))
  # convert date/time
  reprex_data$date <- as.Date(substr(reprex_data$date,1,10), '%Y-%m-%d')
  # adjust date_time to utc (seems to offset things incorrectly)
  #reprex_data$date_time <- anytime::anytime(substr(reprex_data$date_time,1,19), tz='UTC')
  # download data
  return(reprex_data)
  #messari <<- pins::pin_get('messari','messari')

  # writeLines() instead of print() so I can use \n
  #writeLines(paste("Success. The cryptocurrency data is now available in the new object called 'messari'.\nThe most recent data is from:", toString(max(messari$DateTimeColoradoMST)), "(Colorado-MST timezone)."))
}
