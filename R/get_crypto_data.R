#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@export
get_crypto_data <- function(){
  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "d6eae6957752863db7de1f918779ff3535d9a981")

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
