#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@export
get_crypto_data <- function(){
  library(pins)
  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "8b239c30b8ff44ac685fd0fb2c84f4fed9aa67c3")

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
