#' Get a list of Power BI workspaces
#'
#' Returns the ids and meta data of all Power BI workspaces to which the service
#' principal app has been granted access.
#'
#' Required scope: Workspace.Read.All or Workspace.ReadWrite.All
#'
#' @return A data.table / data frame with workspaces.
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

  data.table::rbindlist(resp$value)

}

#' Get a list of datasets in a Power BI workspace
#'
#' Returns the IDs and meta data of all available datasets in the specified
#' Power BI workspace.
#'
#' Required scope: Dataset.ReadWrite.All or Dataset.Read.All
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
#' pbi_list_datasets(my_group_id)
#' }
pbi_list_datasets <- function(group_id) {

  token <- pbi_get_token()

  url <- paste0('https://api.powerbi.com/v1.0/myorg/groups/', group_id ,'/datasets' )
  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- get_request(url = url, header = header)

  value <- suppressWarnings( rbindlist(resp$value))
  value[, group_id := group_id]

  data.table(value)

}

