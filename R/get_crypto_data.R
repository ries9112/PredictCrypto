#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@export
get_crypto_data <- function(){
  library(pins)
  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "6f974e2085af41dea23bc226d84979040d64021e")

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
