#' Get Power BI data type
#'
#' This function detects an R vector's class and converts it into the equivalent
#' data type in Power BI.
#'
#' @param vector An atomic vector of type POSIXt, Date, Factor, Logical, Double,
#'   Integer, Numeric or Character.
#'
#' @return A string indicating the Power BI data type of the vector.
#' @export
#'
#' @examples sapply(iris, pbi_schema_types_infer)

pbi_schema_types_infer <- function(vector) {

  if( !is.atomic(vector) ) stop('The argument must be an atomic vector')

  if (methods::is(vector, "Date")) return("DateTime")
  else if (methods::is(vector, "POSIXt")) return("DateTime")
  else if (is.factor(vector)) return("String")
  else if (is.logical(vector)) return("Boolean")
  else if (is.double(vector)) return("Double")
  else if (is.integer(vector)) return("Int64")
  else return("String")
  }


#' Set Power BI column properties
#'
#' This function defines the Power BI column properties of a data frame.
#'
#' @param dt A data frame.
#' @param table_name The name given to the data frame. Default is 'table1'.
#' @param date_format How the datetime columns should be formatted. Default is
#'   'yyyy-mm-dd'.
#' @param integer_format How the integer columns should be formatted. Default is
#'   '#,###0'.
#' @param double_format How the double columns should be formatted. Default is
#'   '#,###.00'.
#'
#' @return A nested data.table indicating the name of the table and the column
#'   formats.
#' @export
#'

pbi_schema_column_prop <- function(
  dt,
  table_name = "table1",
  date_format = "yyyy-mm-dd",
  integer_format = "#,###0",
  double_format = "#,###.00"
) {

  cols <- names(dt)
  data_types <- sapply(dt, pbi_schema_types_infer)

  format_string <- rep("Standard", length(data_types))

  datetime_index <- which(data_types == "DateTime")
  format_string[datetime_index] <- date_format

  int_index <- which(data_types == "Int64")
  format_string[int_index] <- integer_format

  dob_index <- which(data_types == "Double")
  format_string[dob_index] <- double_format


  table <- jsonlite::unbox(data.table::data.table(
    name = table_name,
    columns = list(
      data.table::data.table(
        name = cols,
        dataType = data_types,
        formatString = format_string
        )
      )
    )
  )

  return(table)

}


#' Set Power BI table properties
#'
#' This function defines the Power BI table properties of a data frame.
#'
#' @param dt A data frame.
#' @param date_format The Power BI format of date columns. Default is 'yyyy-mm-dd'.
#' @param integer_format The Power BI format of integer columns. Default is '#,###0'.
#' @param double_format The Power BI format of double columns. Default is '#,###.00'.
#'
#' @return A nested data.table.
#' @export
#'
#' @examples pbi_schema_table_prop(iris)
pbi_schema_table_prop <- function(
  dt,
  date_format = "yyyy-mm-dd",
  integer_format = "#,###0",
  double_format = "#,###.00"
) {

  schema <- pbi_schema_column_prop(
    dt,
    date_format = date_format,
    integer_format = integer_format,
    double_format = double_format
  )

  return(schema)

}


# Internal api calls ------------------------------------------------------

# pbi_row_push_few <- function(
#   dt,
#   group_id,
#   dataset_id,
#   table_name
# ) {
#
#   rows <- list(rows = dt)
#
#   token <- .pbi_env$token$credentials$access_token
#   stale_token <- lubridate::as_datetime(as.numeric(.pbi_env$token$credentials$expires_on)) <= Sys.time()
#   if(stale_token) .pbi_env$token$refresh()
#
#   url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id, "/datasets/", dataset_id, "/tables/", table_name, "/rows")
#
#   r <- httr::POST(
#     url = URLencode(url),
#     httr::add_headers(
#       Authorization = paste("Bearer", token)
#     ),
#     body = rows,
#     encode = 'json'
#   )
#
#   print(httr::status_code(r))
#   if(!httr::status_code(r)==200) print(httr::content(r))
#
#   return(r)
# }
#
# pbi_schema_table_get <- function(schema, table_name = NULL) {
#
#   tables <- schema[["tables"]]
#
#   nm <- list()
#   for (i in seq_along(tables)) { nm[[i]] <- schema[["tables"]][[i]][["name"]] }
#   nm <- unlist(nm)
#   pos <- match(table_name, nm)
#
#   table_schema <- schema[["tables"]][[pos]]
#   #attr(table_schema, "schema_type") <- "table_schema"
#
#   return(table_schema)
# }

