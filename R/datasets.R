#' Refresh dataset
#'
#' Triggers a refresh for the specified dataset from the specified workspace.
#'
#' @param group_id The ID of the workspace.
#' @param dataset_id The ID of the dataset.
#'
#' @return If successful, the refresh request ID is returned.
#' @seealso \link{pbi_dataset_refresh_hist}
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' dataset_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#'
#' pbi_dataset_refresh(group_id, dataset_id)
#' #> A refresh of dataset xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx was triggered.
#' #>
#' #> To check status, use pbi_dataset_refresh_hist() and the request ID returned
#' #> by this function.
#' #> [1] "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' }
pbi_dataset_refresh <- function(group_id, dataset_id) {

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id, "/refreshes")
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token) )

  resp <- httr::POST(url, header, httr::content_type_json())

  if (httr::http_error(resp)) {stop(httr::content(resp), call. = FALSE)}

  message("\nA refresh of dataset ", dataset_id, " was triggered.\n\n",
          "To check status, use pbi_dataset_refresh_hist() and the request ID returned\nby this function.\n")

  return(resp[["headers"]][["requestid"]])
}

#' Refresh history of a dataset
#'
#' Returns the refresh history for the specified dataset from the specified
#' workspace.
#'
#' @param group_id The workspace ID
#' @param dataset_id The dataset ID
#' @param top The number of most recent entries in the refresh history. The
#'   default is all available entries.
#' @param request_id The request ID returned by pbi_dataset_refresh(). If
#'   provided the refresh status of the request ID is returned.
#'
#' @details By default the function will return all historical refreshes. You
#'   can reduce the list to the most recent refreshes using the \code{top}
#'   argument.
#'
#'   If \code{request_id} is provided the function will return a single refresh
#'   status, but will still query the Power BI API for all historical entries.
#'   If you query the top 5 most recent refreshes using the \code{top} argument,
#'   the function will only return a status if the provided request_id is in
#'   this list.
#'
#'   The status value return can be either 'Completed', 'Failed' or 'Unknown',
#'   which means that the refresh is still in progress.
#'
#' @return A data frame with status, start and end times of historical refreshes
#'   or a single refresh status message if \code{request_id} is used.
#' @seealso \link{pbi_dataset_refresh}
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' dataset_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#'
#' pbi_dataset_refresh_hist(group_id, dataset_id)
#' }
pbi_dataset_refresh_hist <- function(group_id,
                                     dataset_id,
                                     top = NULL,
                                     request_id = NULL) {

  # Due to notes in R CMD check
  value=requestId <- serviceExceptionJson <- NULL

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id)

  if(!is.null(top)) {

    url <- paste0(url, "/refreshes?$top=", top) }

  else {

    url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id, "/refreshes/")

  }

  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- get_request(url = url, header = header)

  value <- suppressWarnings( rbindlist(resp$value, fill = TRUE))
  value[, group_id := group_id]

  error_messages <- value[
    !is.na(serviceExceptionJson),
    rbindlist(lapply(serviceExceptionJson, jsonlite::fromJSON), use.names = TRUE, fill = TRUE),
    by = list(requestId)]

  value <- merge(value, error_messages, all.x = TRUE, by = "requestId")

  if(!is.null(request_id)) {

    refresh_status <- value[requestId == request_id]$status

    message("Refresh status of ", request_id, ":\n", refresh_status)

    return(refresh_status)

  } else {

    data.table::setDF(value)
    return(value)

  }

}

