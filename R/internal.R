#' @title Infer the Power BI data type of a vector
#'
#' @description This function converts the class of a vector to the equivalent data type in Power BI.
#'
#' @param vector A vector of type POSIXt, Date, Factor, Logical, Double, Integer, Numeric or Character.
#'
#' @return A string indicating the Power BI data type of the vector.
#' @export
#'
#' @examples sapply(iris, pbi_schema_types_infer)

pbi_schema_types_infer <- function(vector) {
  if (methods::is(vector, "Date")) return("DateTime")
  else if (methods::is(vector, "POSIXt")) return("DateTime")
  else if (is.factor(vector)) return("String")
  else if (is.logical(vector)) return("Boolean")
  else if (is.double(vector)) return("Double")
  else if (is.integer(vector)) return("Int64")
  else return("String")
  }
