#' Create a Power BI dataset schema
#'
#' Creates a Power BI dataset schema from a set of data frames. Columns and data
#' types will be inferred from the data frames.  Only applicable to push
#' datasets.
#'
#' @param dt_list A list of data frames which the schema should be inferred from.
#' @param dataset_name A custom name of the Power BI dataset.
#' @param table_name_list A list of custom names corresponding to the list of data
#'   frames.
#' @param relations_list A list of relation definitions returned by
#'   pbi_schema_relation_create()
#' @param date_format The format of date columns (if any). Default is
#'   'yyyy-mm-dd'.
#' @param integer_format The format of integer columns (if any). Default is
#'   '#,###0'.
#' @param double_format The format of double columns (if any). Default is
#'   '#,###.00'.
#' @param sort_by_col List of cols to be sorted.
#' @param default_mode The dataset mode or type. Defaults to 'Push'.
#'
#' @import data.table
#' @return A list with schema properties.
#' @export
#'
#' @examples
#' pbi_schema_create(
#'   dt_list = list(iris, mtcars),
#'   dataset_name = "An iris and mtcars dataset",
#'   table_name_list = list("iris", "mtcars")
#'   )
pbi_schema_create <- function(
  dt_list,
  dataset_name = "My Power BI Dataset",
  table_name_list,
  relations_list = NULL,
  date_format = "yyyy-mm-dd",
  integer_format = "#,###0",
  double_format = "#,###.00",
  sort_by_col = NULL,
  default_mode = c("Push", "Streaming", "PushStreaming", "AsOnPrem",
                   "AsAzure")) {

  if(!is.null(sort_by_col)) {

    tbl_index <- which(table_name_list %in% sort_by_col$table)


    for (i in tbl_index) {

      sort_index <- which(sort_by_col$table ==table_name_list[i])

      attr(dt_list[[i]], "sort_table") <- table_name_list[i]
      attr(dt_list[[i]], "sort") <- sort_by_col$sort[sort_index]
      attr(dt_list[[i]], "sort_by") <- sort_by_col$sort_by[sort_index]
    }
  }

  dt_list <- lapply(
    dt_list,
    pbi_schema_table_prop,
    date_format = date_format,
    integer_format = integer_format,
    double_format = double_format
  )

  Map(function(x, y, name) x[, name := y], dt_list, y = table_name_list)

  default_mode <- match.arg(default_mode)

  dt_list <- list(
    name = jsonlite::unbox(dataset_name),
    defaultMode = jsonlite::unbox(default_mode),
    tables = dt_list
  )

  if (!is.null(relations_list)) {

    if(!is.list(relations_list)) stop("relations_list is not an object of class 'list'")

    dt_list <- pbi_schema_add_relations(
      schema = dt_list,
      rel_list = relations_list
    )

  }


  return(dt_list)
}


#' Define table relationship
#'
#' Defines a relationship between tables in a Power BI push dataset. To add this
#' definition to a Power BI dataset schema, use pbi_schema_add_relations().
#'
#' @param from_table The name of the foreign key table
#' @param from_column The name of the foreign key column
#' @param to_table The name of the primary key table
#' @param to_column The name of the primary key column. Defaults to from_column
#' @param direction The filter direction of the relationship. Defaults to
#'   'OneDirection'
#' @param name The relationship name and identifier. Defaults to a concatenation
#'   of from_table, to_table and from_column
#'
#' @return A data.table
#' @export
#'
#' @examples
#' # An example
pbi_schema_relation_create <- function(from_table = NULL,
                                       from_column = NULL,
                                       to_table = NULL,
                                       to_column = from_column,
                                       direction = c("OneDirection", "BothDirections", "Automatic"),
                                       name = paste0(from_table, to_table, from_column)) {

  if(is.null(from_table)) stop("Please specify the table from which the relationship starts (from_table)")
  if(is.null(from_column)) stop("Please specify the joining key column in the 'from_table'")
  if(is.null(to_table)) stop("Please specify the table at which the relationship ends (to_table)")

  direction <- match.arg(direction)

  data.table::data.table(
    name,
    fromTable = from_table,
    fromColumn = from_column,
    toTable = to_table,
    toColumn = to_column,
    crossFilteringBehavior = direction
  )
}




# pbi_schema_add_measures <- function(schema, table_name, measures) {
#
#   setDT(measures)
#   tables <- schema[["tables"]]
#
#   nm <- list()
#   for (i in seq_along(tables)) { nm[[i]] <- schema[["tables"]][[i]][["name"]]}
#   nm <- unlist(nm)
#   pos <- match(table_name, nm)
#
#   old_measures <- schema[["tables"]][[pos]][["measures"]][[1]]
#
#   if (is.data.table(old_measures)) {
#     measures <- rbindlist(list(old_measures, measures))
#     schema[["tables"]][[1]]$measures <- list(measures)
#   } else {
#     schema[["tables"]][[pos]]$measures <- list(measures)
#   }
#
#   return(schema)
#
# }
