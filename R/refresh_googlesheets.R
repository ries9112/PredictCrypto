#'@importFrom RMySQL MySQL
#'@importFrom pins board_register_github
#'@importFrom pins pin_get
#'@importFrom dplyr arrange
refresh_googlesheets <- function(){
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

  cryptoData2 <- dbFetch(dbSendQuery(database_connection, query), 250000)

  #board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "8d1968cd3655c85c301054771bd12bdcc0f03099")
  board_register_github(name = "github", repo = "ries9112/Pins", branch = "master", token = "60e62d78a30e794602650fbeb15cc31c40dd7c24") # all priviliges
  cryptoData2 <<- dplyr::arrange(cryptoData2, desc(DateExtracted))

  pin(cryptoData2,board='github')

  # Disconnect from the database
  dbDisconnect(database_connection)
}








