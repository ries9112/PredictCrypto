#'@importFrom pins board_register
#'@importFrom pins pin_get
#'@export
get_crypto_data_reprex <- function(){

  # register pins board
  pins::board_register("https://raw.githubusercontent.com/predictcrypto/pins/master/",'messari_reprex')

  # download data
  return(pins::pin_get('messari_reprex','messari_reprex'))
  #messari <<- pins::pin_get('messari','messari')

  # writeLines() instead of print() so I can use \n
  #writeLines(paste("Success. The cryptocurrency data is now available in the new object called 'messari'.\nThe most recent data is from:", toString(max(messari$DateTimeColoradoMST)), "(Colorado-MST timezone)."))
}
