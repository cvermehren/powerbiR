#' List Power BI groups (workspaces)
#'
#' @return A data.table with Power BI group ids and meta data.
#' @export
pbi_list_groups <- function() {

  token <- pbi_auth_refresh()

  # token <- .pbi_env$token$credentials$access_token
  # stale_token <- lubridate::as_datetime(as.numeric(.pbi_env$token$credentials$expires_on)) <= Sys.time()
  # if (stale_token) .pbi_env$token$refresh()

  url <- 'https://api.powerbi.com/v1.0/myorg/groups/'
  groups <- httr::GET(url,
                      httr::add_headers(Authorization = paste("Bearer", token)))
  groups <- httr::content(groups)
  groups <- data.table::rbindlist(groups$value)

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
