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

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id,"/datasets")

  #retention <- match.arg(retention)
  retention <- "none"

  if(retention == "basicFIFO") {
    url <- paste0(url, "?defaultRetentionPolicy=basicFIFO")
    }

  r <- httr::POST(
    url = utils::URLencode(url),
    httr::add_headers(
      Authorization = paste("Bearer", token)
    ),
    body = schema,
    encode = "json"
  )

  print(httr::status_code(r))
  if(!httr::status_code(r)==200) print(httr::content(r))
  return(r)

}
