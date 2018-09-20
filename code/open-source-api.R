# install.packages(c("httr", "plyr"))

library(httr)
library(plyr)

run_query <- function(token, hour_from, hour_to, dimensions, metrics, filters = NULL, limit = NULL) {
  auth <- paste("token", token)
  query <- list()
  query[["hour_from"]] <- hour_from
  query[["hour_to"]] <- hour_to
  query[["dimensions"]] <- dimensions
  query[["metrics"]] <- metrics
  if (!is.null(filters)) {
    query[["filters"]] <- filters
  }
  if (!is.null(limit)) {
    query[["limit"]] <- limit
  }
  results <- POST("https://open-source-api.herokuapp.com/",
       body = query,
       encode = "json",
       add_headers(Authorization = auth))
  rows <- content(results)$rows
  ldply (rows, data.frame)
}
