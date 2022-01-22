#' Demo data: Channel Dimension.
#'
#' Anonymized data from google analytics.
#'
#' @format A data frame with 10483 rows and 2 variables:
#' \describe{
#'   \item{channel_key}{customer ID, factor vector}
#'   \item{channel_grouping}{transaction date1}
#'   \item{source}{transaction date2}
#'   \item{medium}{transaction date3}
#'   \item{campaign}{transaction date4}
#'   }
#'
#' @source Google Analytics
"dim_channel"

#' Demo data: Dim Market.
#'
#' Anonymized data from google analytics.
#'
#' @format A data frame with 10483 rows and 2 variables:
#' \describe{
#'   \item{market_key}{customer ID, factor vector a}
#'   \item{view_name}{transaction date1 b}
#'   \item{country}{transaction date2 c}
#'   }
#'
#' @source Google Analytics
"dim_market"

#' Demo data: Fact Web Sales.
#'
#' Anonymized data from google analytics.
#'
#' @format A data frame with 10483 rows and 2 variables:
#' \describe{
#'   \item{date}{customer ID, factor vector a}
#'   \item{market_key}{transaction date2 c}
#'   \item{channel_key}{transaction date2 c}
#'   \item{ad_impressions}{transaction date1 b}
#'   \item{ad_clicks}{transaction date2 c}
#'   \item{ad_cost}{customer ID, factor vector a}
#'   \item{sessions}{transaction date1 b}
#'   \item{transactions}{transaction date2 c}
#'   \item{revenue}{transaction date2 c}
#'   }
#'
#' @source Google Analytics
"fact_websales"
