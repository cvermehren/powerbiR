#' Push a dataset schema to Power BI
#'
#' Pushes a dataset schema to the specified Power BI workspace. To add rows to
#' the dataset, use pbi_push_rows().
#'
#' @param schema A push-dataset schema created by pbi_schema_create().
#' @param group_id The ID of the destination Power BI workspace.
#' @param retention The retention policy of the dataset. Default is "none".
#'
#' @return A dataset with tables will be created in the specified Power BI
#'   workspace.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#'
#' schema <- pbi_schema_create(
#'   dt_list = list(iris),
#'   dataset_name = "The iris dataset",
#'   table_name_list = list(iris)
#' )
#'
#' pbi_push_dataset_schema(schema, group_id)
#' }
pbi_push_dataset_schema <- function(schema,
                                    group_id,
                                    retention = c("none", "basicFIFO")) {

  retention <- match.arg(retention)

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets")
  if(retention == "basicFIFO") {url <- paste0(url, "?defaultRetentionPolicy=basicFIFO")}
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::POST(url, header, body = schema, encode = "json")

  if (httr::http_error(resp)) {

    stop(httr::content(resp), call. = FALSE)

  } else {

    pushed_dataset_id <- httr::content(resp)$id

  }

  message("Successfully added dataset schema to the workspace with ID ",
          group_id )

  return(pushed_dataset_id)

}


#' Push rows to a dataset table
#'
#' Adds new data rows to the specified table within the specified dataset
#' from the specified Power BI workspace. Only applicable to push datasets.
#'
#' The Power BI REST has a limit of 10K rows per POST rows request. This limit
#' is handled by splitting the data frame into chunks of 10K rows each and
#' pushing these chunks one at a time. However, you should manually observe the
#' other limitations of the API. See
#' \url{https://docs.microsoft.com/en-au/rest/api/power-bi/} for more details.
#'
#' @param dt A data frame with rows to be added to the specified Power BI table
#'   (table_name). The columns and data types must match the specified table.
#' @param group_id The ID of the destination Power BI workspace.
#' @param dataset_id The ID of the destination Power BI dataset.
#' @param table_name The name of the destination Power BI table.
#' @param overwrite If TRUE, existing rows will be deleted prior to adding new
#'   rows. If FALSE, the new rows will be appended to the existing rows.
#'
#' @return A dataset with tables and optionally defined relationships will be
#'   created in the specified Power BI workspace.
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' group_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#' dataset_id <- "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
#'
#' pbi_push_rows(group_id, dataset_id, "My table")
#' }
pbi_push_rows <- function(dt,
                          group_id,
                          dataset_id,
                          table_name,
                          overwrite = FALSE) {

  if(overwrite) pbi_delete_rows(group_id, dataset_id, table_name)

  push_list <- split(dt, (as.numeric(rownames(dt))-1) %/% 10000)

  return(invisible(
    lapply(
      push_list,
      pbi_row_push_few,
      group_id = group_id,
      dataset_id = dataset_id,
      table_name = table_name
      )
    )
  )

}
