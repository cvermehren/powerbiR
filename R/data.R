#' Demo data: Dim Channel
#'
#' A look-up dimension related to Fact Web Sales through the channel_key column.
#'
#' @format A data frame with 616 rows and 5 columns: \describe{
#'   \item{channel_key}{Primary key (unique identifyer of channels).}
#'   \item{channel_grouping}{The main type of channel, e.g. Email, Social.}
#'   \item{source}{The source of referrals.}
#'   \item{medium}{The type of referrals.}
#'   \item{campaign}{The name of the campaign.} }
#'
#' @source Anonymized data from google analytics.
"dim_channel"

#' Demo data: Dim Market
#'
#' A look-up dimension related to Fact Web Sales through the market_key column.
#'
#' @format A data frame with 2 rows and 3 columns:
#' \describe{
#'   \item{market_key}{Primary key (unique identifyer of markets).}
#'   \item{view_name}{The name of the Google Analytics View.}
#'   \item{country}{The country associated with the Google Analytics View.}
#'   }
#'
#' @source Anonymized data from google analytics.
"dim_market"

#' Demo data: Fact Web Sales
#'
#' A fact table showing number of visits, transactions, revenue and advertising
#' metrics by date, channel and market.
#'
#' @format A data frame with 1,500 rows and 9 columns:
#' \describe{
#'   \item{date}{The date of the fact.}
#'   \item{market_key}{Foreign key referring to dim_market.}
#'   \item{channel_key}{Foreign key referring to dim_channel}
#'   \item{ad_impressions}{The number of impressions of the associated ad.}
#'   \item{ad_clicks}{The number of times a user has cliked on the associated
#'   ad.}
#'   \item{ad_cost}{The total cost of the ad in USD.}
#'   \item{sessions}{The number of visits from the associated channel.}
#'   \item{transactions}{The number of purchases mediated by the associated
#'   channel.}
#'   \item{revenue}{The total value of purchases mediated by the associated
#'   channel.}
#'   }
#'
#' @source Anonymized data from google analytics.
"fact_websales"
