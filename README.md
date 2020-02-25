[![codecov](https://codecov.io/gh/ries9112/PredictCrypto/branch/master/graph/badge.svg)](https://codecov.io/gh/ries9112/PredictCrypto)

# PredictCrypto

# This package is not ready yet and is here so I can use it for my own development

`PredictCrypto` is a website on which I offer free programming tutorials using cryptocurrency data that is never outdated by more than 1 hour: https://www.predictcrypto.com/tutorials

## Installation

``` r
library(devtools)
install_github("ries9112/PredictCrypto")
```

## Usage

Create a new dataset with cryptocurrency data
``` r
crypto_data <- get_crypto_data()
```

Calculate the % change over a certain number of hours
``` r
crypto_data <- calculate_perc_change(crypto_data, 24, 'hours')
```

## Examples


## To-do

* Setup CI to refresh data `cryptoData` that comes with the package hourly

* Document functions

* Calculate target % change using BTC instead of USD

* Create variable names based on hours chosen for % change calculation

* Create data by exchange made available through package

* Create plotting functions
