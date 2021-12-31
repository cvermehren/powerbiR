#' List Power BI groups (workspaces)
#'
#' @return A data.table with Power BI group ids and meta data.
#' @export
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


#' Title
#'
#' @param group_id The group id
#'
#' @return A table
#' @export
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
