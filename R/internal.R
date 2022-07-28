
get_request <- function(url, header) {

  resp <- httr::GET(url, header)

  if (httr::http_error(resp)) stop(httr::content(resp), call. = FALSE)

  resp <- httr::content(resp, "text", encoding = "UTF-8")
  resp <- try(jsonlite::fromJSON(resp, simplifyVector = FALSE))

  if (inherits(resp, "try-error")) {
    stop("The Power BI API returned an empty value or the value could not be parsed.")
  }

  return(resp)
}


# Infer Power BI data types from a data frame. Used in pbi_schema_column_prop().
pbi_schema_types_infer <- function(vector) {

  if( !is.atomic(vector) ) stop('The argument must be an atomic vector')

  if (inherits(vector, "Date")) return("DateTime")
  else if (inherits(vector, "POSIXt")) return("DateTime")
  else if (inherits(vector, "POSIXct")) return("DateTime")
  else if (inherits(vector, "factor")) return("String")
  else if (inherits(vector, "logical")) return("Boolean")
  else if (inherits(vector, "numeric")) return("Double")
  else if (inherits(vector, "integer")) return("Int64")
  else return("String")
}


# Define Power BI formats for columns of a data frame. Used in pbi_schema_table_prop().
pbi_schema_column_prop <- function(dt,
                                   table_name = "table1",
                                   date_format = "yyyy-mm-dd",
                                   integer_format = "#,###0",
                                   double_format = "#,###.00") {

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

  if(!is.null(attr(dt, "sort_by_cols"))) {

    sort_by_cols <- attr(dt, "sort_by_cols")
    table$columns[[1]] <- sort_by_cols[table$columns[[1]], on = "name"]

  }

  if(!is.null(attr(dt, "hidden_cols"))) {

    hidden_cols <- attr(dt, "hidden_cols")
    table$columns[[1]] <- hidden_cols[table$columns[[1]], on = "name"]

  }

  return(table)

}

pbi_schema_sort <- function(dt, sort = NULL, sort_by = NULL) {

  sorttbl <- data.table(name = sort, sortByColumn = sort_by)
  attr(dt, "sort_by_cols") <- sorttbl

  return(dt)

}


pbi_schema_hidden <- function(dt, hidden = NULL) {

  hidtbl <- data.table(name = hidden, isHidden = TRUE)
  attr(dt, "hidden_cols") <- hidtbl

  return(dt)

}


pbi_schema_table_prop <- function(dt,
                                  date_format = "yyyy-mm-dd",
                                  integer_format = "#,###0",
                                  double_format = "#,###.00") {

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

  return(table_schema)
}


# Define Power BI table relations
# schema: A schema object from pbi_schema_create()
# rel_list: A list of relations as returned by pbi_schema_relation_create()

pbi_schema_add_relations <- function(schema, rel_list) {

  rel_list <- lapply(rel_list, jsonlite::unbox)

  rel <- list(relationships = rel_list)
  new_schema <- append(schema, rel)

  return(new_schema)

}


# Internal api calls ------------------------------------------------------


pbi_row_push_few <- function(dt,
                             group_id,
                             dataset_id,
                             table_name) {

  rowcount <- nrow(dt)

  token <- pbi_get_token()

  url <- paste0("https://api.powerbi.com/v1.0/myorg/groups/", group_id, "/datasets/", dataset_id, "/tables/", table_name, "/rows")
  url <- utils::URLencode(url)

  header <- httr::add_headers(Authorization = paste("Bearer", token))

  rows <- list(rows = dt)

  resp <- httr::POST(url, header, body = rows, encode = 'json')

  if (httr::http_error(resp)) {stop(httr::content(resp), call. = FALSE)}

  message("Successfully added ", rowcount," rows to ", table_name)

  }
