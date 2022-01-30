#' Refresh dataset
#'
#' Triggers a refresh for the specified dataset from the specified workspace.
#'
#' @param group_id The ID of the workspace.
#' @param dataset_id The ID of the dataset.
#' @param notify Mail notification options. Must be one of 'MailOnFailure',
#'   'MailOnCompletion', 'NoNotification'. Defaults to 'MailOnFailure'.
#'
#' @return The specified dataset will be refreshed.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_dataset_refresh(group_id, dataset_id)
#' }
pbi_dataset_refresh <- function(group_id,
                                dataset_id,
                                notify = c("MailOnFailure", "MailOnCompletion",
                                           "NoNotification")) {

  notify <- match.arg(notify)
  notify <- list(notifyOption = notify)
  notify <- jsonlite::toJSON(notify)

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id, "/refreshes")
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token) )

  resp <- httr::POST(url, header, body = notify, httr::content_type_json())

  if (httr::http_error(resp)) {stop(httr::content(resp), call. = FALSE)}



  message("Successfully refreshed dataset with ID ", dataset_id )

  resp[["headers"]][["requestid"]]

}


# # Request ID from historical refresh request
# request_id <- "18af7872-a474-43d8-adce-8c2cffd7d2dc"
#
# # Find refresh ID
# get_index <-function(x) {x$requestId %in% id}
# request_index <- which(sapply(resp[["value"]], get_index))
# resp[["value"]][[index]]$requestId


pbi_dataset_refresh_hist <- function(group_id, dataset_id, request_id = NULL) {

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id, "/refreshes/")
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token) )

  resp <- httr::GET(url, header)

  if (httr::http_error(resp)) {stop(httr::content(resp), call. = FALSE)}

  #request_id <- resp[["headers"]][["requestid"]]

  resp <- httr::content(resp)
  resp <- rbindlist(resp$value, fill = TRUE)

  if(!is.null(request_id)) resp[resp$requestId == request_id]$status

}
