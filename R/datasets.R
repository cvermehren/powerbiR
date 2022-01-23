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

}
