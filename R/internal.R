#' @title Get Power BI data type
#'
#' @description This function detects an R vector's class and converts it into the equivalent data type in Power BI.
#'
#' @param vector An atomic vector of type POSIXt, Date, Factor, Logical, Double, Integer, Numeric or Character.
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
#' @param date_format How the datetime columns should be formatted. Default is 'yyyy-mm-dd'.
#' @param integer_format How the integer columns should be formatted. Default is '#,###0'.
#' @param double_format How the double columns should be formatted. Default is '#,###.00'.
#'
#' @return A nested data.table indicating the name of the table and the column formats.
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

#test <- pbi_schema_column_prop(iris)
