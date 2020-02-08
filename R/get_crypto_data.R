#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom safer decrypt_string
#'@export
get_crypto_data <- function(){
  pins::board_register_github(name = "github", repo = "predictcrypto/pins", branch = "master", token = safer::decrypt_string("PCH6/gtU3p2QWhSFgCIWKELXj/QFm/DIQi20B2A20NobHWGn03T7KiUBgZ6Zw4XLLAMJB3Pdx+4=", toString(20.5*6)))

  # Pull data from board
  cryptoData <<- pin_get('cryptoData','github') # double << lets it be part of global environment from function

  #cryptoData <<- utils::type.convert(cryptoData, as.is=TRUE) # as.is keeps characters instead of factors

  return(cryptoData)
}
