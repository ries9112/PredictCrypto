#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom safer decrypt_string
#'@export
get_crypto_data <- function(){
  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = paste0("b2ebaef07fa3d4abe316aed8a9608f4e7ca",  decrypt_string("KBQgbvYOq2IRVC16tdbn+esMMQ==","120"), "a4"))

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
