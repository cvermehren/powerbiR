#' Get a list of workspaces
#'
#' Returns the ids and meta data of all Power BI workspaces to which the service
#' principal app has been granted access.
#'
#' @return A data frame with workspaces.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_list_groups()
#' }
pbi_list_groups <- function() {

  token <- pbi_get_token()

  url <- 'https://api.powerbi.com/v1.0/myorg/groups/'
  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::GET(url, header)

  if (httr::http_error(resp)) stop(httr::content(resp), call. = FALSE)

  resp <- httr::content(resp, "text", encoding = "UTF-8")
  resp <- try(jsonlite::fromJSON(resp, simplifyVector = FALSE))

  if (inherits(resp, "try-error")) {
    stop("The Power BI API returned an empty value or the value could not be parsed.")
  }

  value <- data.table::rbindlist(resp$value)
  data.table::setDF(value)

  return(value)

}

#' Get a list of datasets in a workspace
#'
#' Returns the IDs and meta data of all available datasets in the specified
#' Power BI workspace (group ID).
#'
#' @param group_id The Power BI workspace ID.
#'
#' @return A data.table / data frame with dataset information.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#'
#' pbi_list_datasets(group_id)
#' }
pbi_list_datasets <- function(group_id) {

  token <- pbi_get_token()

  url <- paste0('https://api.powerbi.com/v1.0/myorg/groups/', group_id ,'/datasets' )
  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- get_request(url = url, header = header)

  value <- suppressWarnings( rbindlist(resp$value))
  value[, group_id := group_id]

  data.table::setDF(value)
  return(value)

}

