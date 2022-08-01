#' Demo data: Dim Hour
#'
#' A look-up dimension related to Fact Visitors through the hour_key column.
#'
#' @format A data frame with 24 rows and 2 columns:
#' \describe{
#'   \item{hour_key}{Primary key (unique identifier of hour).}
#'   \item{hour}{Hour as a name (character type).}
#'   }
#'
#' @source Anonymized data from google analytics.
"dim_hour"

#' Demo data: Fact Visitors
#'
#' A fact table showing individual visitors and their transactions on an
#' e-commerce website.
#'
#' @format A data frame with 10,033 rows and 5 columns:
#' \describe{
#'   \item{visitor_id}{Unique identifier of the visitor.}
#'   \item{transaction_id}{Unique identifier of the transactions.}
#'   \item{revenue}{The value of the transaction in USD.}
#'   \item{timestamp}{The time of visit in minutes since 1970-01-01.}
#'   \item{hour_key}{Foreign key referring to dim_hour.}
#'   }
#'
#' @source Anonymized data from google analytics.
"fact_visitors"
