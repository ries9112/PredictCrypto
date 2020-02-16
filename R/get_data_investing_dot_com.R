#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom safer decrypt_string
#'@export
get_data_investing_dot_com <- function(){
  pins::board_register_github(name = "github", repo = "predictcrypto/pins", branch = "master", token = paste0("b2ebaef07fa3d4abe316aed8a9608f4e7ca",  decrypt_string("KBQgbvYOq2IRVC16tdbn+esMMQ==","120"), "a4"))

  return(pins::pin_get("investing-dot-com",board='github'))
}

