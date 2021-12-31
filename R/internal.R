# Infer Power BI data types from a data frame. Used in pbi_schema_column_prop().
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

# Define Power BI formats for columns of a data frame. Used in pbi_schema_table_prop().
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

# Used in pbi_push_table()
pbi_schema_table_get <- function(schema, table_name = NULL) {

  tables <- schema[["tables"]]

  nm <- list()
  for (i in seq_along(tables)) { nm[[i]] <- schema[["tables"]][[i]][["name"]] }
  nm <- unlist(nm)
  pos <- match(table_name, nm)

  table_schema <- schema[["tables"]][[pos]]
  #attr(table_schema, "schema_type") <- "table_schema"

  return(table_schema)
}


# Internal api calls ------------------------------------------------------

pbi_row_push_few <- function(
  dt,
  group_id,
  dataset_id,
  table_name
) {

  rows <- list(rows = dt)

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id, "/datasets/", dataset_id, "/tables/", table_name, "/rows")

  resp <- httr::POST(
    url =  utils::URLencode(url),
    httr::add_headers(
      Authorization = paste("Bearer", token)
    ),
    body = rows,
    encode = 'json'
  )

  httr::message_for_status(resp)
  if(!httr::status_code(resp)==200) print(httr::content(resp))

  return(resp)
}


