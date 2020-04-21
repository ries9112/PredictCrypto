#'@importFrom pins board_register
#'@importFrom pins pin_get
#'@export
get_crypto_data <- function(){

  # register pins board
  pins::board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/",'messari')

  # download data
  pins::pin_get('messari','messari')
  #messari <<- pins::pin_get('messari','messari')

  # writeLines() instead of print() so I can use \n
  #writeLines(paste("Success. The cryptocurrency data is now available in the new object called 'messari'.\nThe most recent data is from:", toString(max(messari$DateTimeColoradoMST)), "(Colorado-MST timezone)."))
}
