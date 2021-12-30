#' Create schema
#'
#' @param dt_list A list of data frames
#' @param dataset_name The name of the Power BI dataset.
#' @param table_name_list A list of names corresponding to the list of data
#'   frames.
#' @param date_format The format of the date columns (if any). Default is
#'   'yyyy-mm-dd'.
#' @param integer_format The format of the integer columns (if any). Default is
#'   '#,###0'.
#' @param double_format The format of the double columns (if any). Default is
#'   '#,###.00'.
#' @param default_mode The dataset mode or type.
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
  date_format = "yyyy-mm-dd",
  integer_format = "#,###0",
  double_format = "#,###.00",
  default_mode = c("Push", "Streaming", "PushStreaming", "AsOnPrem", "AsAzure")
  ) {

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

  return(dt_list)
}

#' Define Power BI table relations
#'
#' @param schema A schema object from pbi_schema_create()
#' @param rel_list A list of relations.
#'
#' @return An updated schema including relations definitions.
#' @export
#'
#' @examples
#'
#' # Dummy data: Two data frames with shared ID columns.
#' df1 <- swiss
#' df1$id <- rownames(df1)
#'
#' df2 <- swiss
#' df2$id <- rownames(df2)
#' df2$var <- rnorm(nrow(df2), 10, 4)
#' df2 <- df2[, c("id", "var" )]
#'
#' # Create schema
#' table_list <- list(df1, df2)
#' table_names  <- c("DF1", "DF2")
#' dataset_name <- "MyDataSet"
#'
#' schema <- pbi_schema_create(
#'   dt_list = table_list,
#'   dataset_name = dataset_name,
#'   table_name_list = table_names
#'   )
#'
#' # Add relations definitions
#' relations <- data.frame(
#'   name = "MyUniqueRelationsID",
#'   fromTable = "swiss",
#'   fromColumn = "id",
#'   toTable = "swiss_dummy",
#'   toColumn = "id",
#'   crossFilteringBehavior = "bothDirections"
#'   )
#'
#' # Add relations to schema
#' relations_list <- list(relations)
#'
#' schema <- pbi_schema_add_relations(
#'   schema = schema,
#'   rel_list = relations_list
#'   )
pbi_schema_add_relations <- function(schema, rel_list) {

  rel_list <- lapply(rel_list, jsonlite::unbox)

  rel <- list(relationships = rel_list)
  new_schema <- append(schema, rel)
  return(new_schema)

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
