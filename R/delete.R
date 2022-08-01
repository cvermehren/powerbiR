#' Delete rows
#'
#' Deletes all rows from the specified table within the specified dataset
#' from the specified workspace (group ID). Only applicable to push datasets.
#'
#' @param group_id The Power BI workspace ID.
#' @param dataset_id The Power BI dataset ID.
#' @param table_name The Power BI table name.
#'
#' @return All rows will be deleted from the specified table.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' dataset_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' table_name <- "My Table"
#'
#' pbi_delete_rows(group_id, dataset_id, table_name)
#' }
pbi_delete_rows <- function(group_id, dataset_id, table_name) {

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id, "/datasets/", dataset_id, "/tables/", table_name, "/rows")
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::DELETE(url, header)

  if (httr::http_error(resp)) {stop(httr::content(resp), call. = FALSE)}

  message("Successfully deleted all rows from ", table_name)

}

#' Delete dataset
#'
#' Deletes the specified dataset from the specified workspace. Applicable to
#' push datasets as well as imported datasets.
#'
#' @param group_id The dataset ID.
#' @param dataset_id The workspace ID.
#'
#' @return Deletes the entire dataset.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' dataset_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#'
#' pbi_delete_dataset(group_id, dataset_id)
#' }
pbi_delete_dataset <- function(group_id, dataset_id) {

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets/", dataset_id)
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::DELETE(url, header)

  if (httr::http_error(resp)) {stop(httr::content(resp), call. = FALSE)}

  message("Successfully deleted dataset with ID ", dataset_id)

}
