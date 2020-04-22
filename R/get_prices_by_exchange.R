#'@importFrom pins board_register
#'@importFrom pins pin_get
#'@export
get_prices_by_exchange <- function(){

  # register pins board
  pins::board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/",'prices')

  # download data
  return(pins::pin_get('shrimpy_prices','prices'))
  #messari <<- pins::pin_get('messari','messari')

  # writeLines() instead of print() so I can use \n
  #writeLines(paste("Success. The cryptocurrency data is now available in the new object called 'messari'.\nThe most recent data is from:", toString(max(messari$DateTimeColoradoMST)), "(Colorado-MST timezone)."))
}
