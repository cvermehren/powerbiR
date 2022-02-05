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


#' Refresh history of a dataset
#'
#' Returns the refresh history for the specified dataset from the specified workspace.
#'
#' @param group_id The workspace ID
#' @param dataset_id The dataset ID
#'
#' @return A data frame
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_dataset_refresh_hist(group_id, dataset_id)
#' }
pbi_dataset_refresh_hist <- function(group_id, dataset_id) {

  # Due to notes in R CMD check
  value=requestId=serviceExceptionJson=NULL

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id, "/refreshes/")
  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- get_request(url = url, header = header)

  value <- suppressWarnings( rbindlist(value, fill = TRUE))
  value[, group_id := group_id]

  error_messages <- value[
    !is.na(serviceExceptionJson),
    rbindlist(lapply(serviceExceptionJson, jsonlite::fromJSON), use.names = TRUE, fill = TRUE),
    by = list(requestId)]

  value <- merge(value, error_messages, all.x = T)
  value
}

