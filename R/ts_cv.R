
# FINAL VERSION NEEDS TO TAKE THE DATE FIELD INSTEAD OF ASSUMING IT'S NAMED A CERTAIN WAY
ts_cv <- function(dataset, train_test_split_percent=.7, cv_folds=5){

  #need to import packages dplyr and tidyr for this function

  dataset <- dataset %>%
    dplyr::arrange(DateExtracted) %>%
    dplyr::mutate(cv_fold = ntile(DateExtracted, cv_folds))


  quantiles_train <- dataset %>%
    dplyr::group_by(cv_fold) %>%
    dplyr::mutate(training='train') %>%
    dplyr::filter(DateExtracted <= quantile(DateExtracted, train_test_split_percent))

  quantiles_test <- dataset %>%
    dplyr::group_by(cv_fold) %>%
    dplyr::mutate(training='test') %>%
    dplyr::filter(DateExtracted > quantile(DateExtracted, train_test_split_percent))

  quantiles_new <- union(quantiles_test, quantiles_train)

  quantiles_grouped <- quantiles_new %>%
    tidyr::nest(-cv_fold, -training) %>%
    tidyr::spread(training, data)

  return(quantiles_grouped)
}
