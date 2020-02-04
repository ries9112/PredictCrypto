#'@importFrom RMySQL MySQL
#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom dplyr arrange
#'@importFrom vroom vroom
refresh_pin <- function(){
  Sys.setenv(user='tutorials', pswd='WebsiteTutorials',ipAddress='35.188.12.15')
  getSqlConnection <- function(){
    con <-
      dbConnect(
        RMySQL::MySQL(),
        username = Sys.getenv('user'),
        password = Sys.getenv('pswd'),
        host = Sys.getenv('ipAddress'),
        dbname = 'ScrapeStorm'
      )
    return(con)
  }

  database_connection <- getSqlConnection()
  tables_list <- dbListTables(database_connection)


  query <- "SELECT Date as 'DateExtracted', DateTime as 'DateTimeColoradoTimeMST', Name, Rank, PriceUSD, PriceBTC, PercChange24hVsUSD, PercChange24hVsBTC, Reported_MarketCap, Reported24hVolume, VolumeTurnover24h, Reported_Supply, CurrentInflation, ATH_USD, TimeFromATH, PercDownFromATH, BreakevenMultiple, PercUpSinceLow, PercChange7d, PercChange7d_BTC, PercChange30d, PercChange30d_BTC, PercChange90d, PercChange90d_BTC, PercChange1y,PercChange1y_BTC, PercChange_MTD, PercChange_QTD, PercChange_YTD, NetworkPercStaking, FlipsideFCAS_Grade, FlipsideFCAS_Rating, FlipsideScore_Dev, FlipsideScore_Utility, FlipsideScore_Maturity, TokenInsight_Grade, TokenInsight_TeamScore, TokenInsight_SubjectScore, TxVol24h, AdjstedTxVol24h, MedianTxValueUSD, ActiveAddresses, Transactions24h, Fees24hUSD, MedianFeeUSD, AvgDifficulty, KilobytesAdded24h, NumBlocks24h, Git_Stars, Git_Watchers, Git_CommitsLast90Days, Git_CommitsLastYear, Git_LinesAddedLast90Days, Git_LinesAddedLastYear, Git_LinesRemovedLast90Days, Git_LinesRemovedLastYear, ROI_2018, ROI_2017, ROI_2016, Volatility30d, Volatility90d, Volatility1y, Volatility3y, Sharpe30d, Sharpe90d, Sharpe1y, Sharpe3y, BlockReward, TargetBlockTimeSeconds, OnChainGovernanceStructure, IsTreasuryDecentralized, LaunchStyle, MiningAlgorithm, NextHalvingDate, GenesisBlockDate, Age, HasExperienced51PercAttack, EmissionType_General, EmissionType_Precise, IsSupplyCapped, MaxSupply, Sector, Category, TokenUsage, TokenType, ConsensusAlgorithm, pkDummy FROM Messari WHERE Date >= date_sub(now(), INTERVAL 7 DAY) AND Name != '' order by pkDummy desc, cast(Rank as unsigned) asc" #Manually picked all fields that could be interesting

  cryptoData <- dbFetch(dbSendQuery(database_connection, query), 250000)

  cryptoData <- dplyr::arrange(cryptoData, desc(DateExtracted))

  fileName <- paste0('cryptoData-',as.integer(Sys.time()),'.csv')

  write.csv(cryptoData, fileName)
  cryptoData <<- vroom::vroom(fileName)

  pins::board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "d6eae6957752863db7de1f918779ff3535d9a981")

  pins::pin(cryptoData,board='github')

  # Disconnect from the database
  dbDisconnect(database_connection)
}
