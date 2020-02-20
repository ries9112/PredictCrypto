#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom safer decrypt_string
#'@importFrom anytime anytime
#'@importFrom lubridate seconds
#'@export
get_crypto_data <- function(){

  #FOR FINAL VERSION: FINAL VERSION SHOULD HAVE STALE DATA IN data/ FOLDER AND PULL DATA THAT IS UPDATED HOURLY LIKE THIS
  # hourly uploads should be on Alteryx hourly to start and should move to cron jobs on cloud computer later

  pins::board_register_github(name = "github", repo = "predictcrypto/pins", branch = "master", token = paste0("b2ebaef07fa3d4abe316aed8a9608f4e7ca",  decrypt_string("KBQgbvYOq2IRVC16tdbn+esMMQ==","120"), "a4"))

  # Pull data from board
  coin_metrics <- pin_get('coin-metrics','github')
  coin_metrics <- utils::type.convert(coin_metrics, as.is=TRUE)
  coin_metrics$date <- anytime(coin_metrics$date) # double << lets it be part of global environment from function
  ### MAKE DUMMY date_time FIELD FOR calulcate_percent_change()
  coin_metrics$date_time <<- coin_metrics$date + lubridate::seconds(1)
  ###

  investing_dot_com_poloniex <- pin_get('investing-dot-com-poloniex','github')
  investing_dot_com_poloniex <- utils::type.convert(investing_dot_com_poloniex, as.is=TRUE) # as.is keeps characters instead of factors
  investing_dot_com_poloniex$date <- anytime(investing_dot_com_poloniex$date)
  ### MAKE DUMMY date_time FIELD FOR calulcate_percent_change()
  investing_dot_com_poloniex$date_time <<- investing_dot_com_poloniex$date + seconds(1)
  ###

  #return(crypto_data)
  print("The data frames 'coin_metrics' and 'investing_dot_com_poloniex' were successfully created inside your R session")
}
