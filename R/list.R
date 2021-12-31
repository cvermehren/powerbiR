#' Get Power BI workspaces
#'
#' Returns the ids and meta data of all Power BI workspaces to which the service
#' principal app has been granted access.
#'
#' @return A data.table / data frame.
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

  httr::stop_for_status(resp)

  resp <- httr::content(resp)
  groups <- data.table::rbindlist(resp$value)

  return(groups)

}


#' Get datasets in workspace
#'
#' Returns the ids and meta data of all available datasets in a specific
#' Power BI workspace.
#'
#' @param group_id The Power BI workspace id
#'
#' @return A data.table / data frame.
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
  resp <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", token)))

  httr::stop_for_status(resp)

  resp <- httr::content(resp)
  resp <- suppressWarnings( rbindlist(resp$value))

  resp[, group_id := group_id]

  data.table(resp)


}
