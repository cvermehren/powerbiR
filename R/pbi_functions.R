#' Infer the data type of a vector
#'
#'
#' @param dt A vector of type POSIXt, Factor, Logical, Double or Integer
#'
#' @return A string indicating the type of the vector
#' @export
#'
#' @examples sapply(iris, pbi_schema_types_infer)
pbi_schema_types_infer <- function(dt) {
  if (methods::is(dt, "Date")) return("DateTime")
  else if (methods::is(dt, "POSIXt")) return("DateTime")
  else if (is.factor(dt)) return("String")
  else if (is.logical(dt)) return("Boolean")
  else if (is.double(dt)) return("Double")
  else if (is.integer(dt)) return("Int64")
  else return("String")

}




