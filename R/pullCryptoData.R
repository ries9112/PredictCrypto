#'@importFrom RMySQL MySQL
pullCryptoData <- function(tablenameQuery = c('Messari'), ...){
  con <-
    dbConnect(
      RMySQL::MySQL(),
      username = Sys.getenv('user'),
      password = Sys.getenv('pswd'),
      host = Sys.getenv('ipAddress'),
      dbname = 'ScrapeStorm'
    )

  subquery <- paste0("(SELECT max(pkDummy) ", "FROM ", tablenameQuery,")" )
  query <- paste0("SELECT ", paste(..., sep=", "), ",pkDummy FROM ", tablenameQuery, " WHERE pkDummy = ", subquery)

# maybe use dbplyr instead, probably sturdier solution.
  query <- query

  latestCryptoData <- dbFetch(dbSendQuery(con, query), 30000) # Public version could limit request by returning limited amount of rows

  # Disconnect from the database
  dbDisconnect(con)
  # Disconnect all connections just to be safe
  #lapply(dbListConnections(dbDriver(drv = "MySQL")), dbDisconnect)

  return(latestCryptoData)

  #return(query)
}







