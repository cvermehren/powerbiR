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


# pbi_list_datasets <- function(group_id) {
#
#   token <- .pbi_env$token$credentials$access_token
#   stale_token <- lubridate::as_datetime(as.numeric(.pbi_env$token$credentials$expires_on)) <= Sys.time()
#   if(stale_token) .pbi_env$token$refresh()
#
#   url <- paste0('https://api.powerbi.com/v1.0/myorg/groups/', group_id ,'/datasets' )
#   datasets <- httr::GET(url, httr::add_headers(Authorization = paste("Bearer", token)))
#   datasets <- httr::content(datasets)
#   datasets <- rbindlist(datasets$value)
#
#   datasets[, group_id := group_id]
#
#   data.table(datasets)
#
#
# }
