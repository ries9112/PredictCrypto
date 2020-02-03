#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@export
get_crypto_data <- function(){
  library(pins)
  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "60e62d78a30e794602650fbeb15cc31c40dd7c24")

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
