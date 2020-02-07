#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom safer decrypt_string
#'@export
get_crypto_data <- function(){
  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = decrypt_string("+MKmN4M7IPrv/ozonR1SpkTSj/gKyPOcECnnAm9v1YhNGjOk3nf8eiACiZWckdKYLVEJV3eNlew=", toString(20.5*6)))

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
