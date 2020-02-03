# Add roxygen skeleton, using dplyr!
calculate_perc_Change <- function(cryptoData, hours){

  # offset hours by specified amount
  cryptoDataOffset <- cryptoData
  cryptoDataOffset$DateTimeExtractedColoradoMSTtime <- #add 3 hours to variable and overwrite it

  # now overwrite pkDummy with offset pkDummy
  cryptoDataOffset$pkDummy <-

  # now create new pkey
  cryptoDataOffset$pkey <- paste0(cryptoDataOffset$pkDummy, cryptoDataOffset$Name)

  # rename the priceUSD to be PriceUSD_x_hours_later
  dplyr::rename(cryptoDataOffset, PriceUSD_x_hours_later = PriceUSD)

  # now join the data

  # calculate % change between values


}

# remember to create a function just like this but pre-made for a 24 hour period called calculate_24hour_perc_change()
