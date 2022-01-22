
#' Title
#'
#' This is my description.
#'
#' @param group_id The grp id
#' @param dataset_id The dataset id
#' @param table_name The table name
#'
#' @return Rows will be deleted
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_delete_rows(group_id, dataset_id, table_name)
#' }
pbi_delete_rows <- function(group_id, dataset_id, table_name) {

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id, "/datasets/", dataset_id, "/tables/", table_name, "/rows")
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::DELETE(url, header)

  if (httr::http_error(resp)) {stop(resp, call. = FALSE)}

  message("Successfully deleted all rows from ", table_name)

}

#' Title
#'
#' My description
#'
#' @param group_id Grp id
#' @param dataset_id test
#'
#' @return Deleted rows
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_delete_dataset(group_id, dataset_id)
#' }
pbi_delete_dataset <- function(group_id, dataset_id) {

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id)
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::DELETE(url, header)

  if (httr::http_error(resp)) {stop(resp, call. = FALSE)}

  message("Successfully deleted dataset with ID ", dataset_id)

}
