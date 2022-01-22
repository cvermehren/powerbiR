#' Push Dataset
#'
#' Pushes a dataset to a Power BI workspace.
#'
#' @param schema A push-dataset schema created by pbi_schema_create()
#' @param group_id The ID of the destination Power BI workspace
#' @param retention The retention policy of the dataset. Default is "none"
#'
#' @return A dataset with tables and optionally defined relationships will be
#'   created in the specified Power BI workspace
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_push_dataset(my_schema, my_group_id)
#' }
pbi_push_dataset <- function(schema,
                             group_id,
                             retention = c("none", "basicFIFO")) {

  retention <- match.arg(retention)

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets")
  if(retention == "basicFIFO") {url <- paste0(url, "?defaultRetentionPolicy=basicFIFO")}
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  resp <- httr::POST(url, header, body = schema, encode = "json")

  if (httr::http_error(resp)) {stop(resp, call. = FALSE)}

  message("Successful push, status code: ", httr::status_code(resp))

}


#' Title
#'
#' My description
#'
#' @param dt A data.table
#' @param group_id The grp id, workspace
#' @param dataset_id The dataset
#' @param table_name The name of the table
#'
#' @return A dataset with tables and optionally defined relationships will be
#'   created in the specified Power BI workspace
#' @export
#'
#' @examples
#'
#' \dontrun{
#'
#' pbi_push_rows(my_data, my_group_id)
#' }
pbi_push_rows <- function(dt, group_id, dataset_id, table_name) {

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
