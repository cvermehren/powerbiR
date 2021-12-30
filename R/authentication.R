.pbi_env <- new.env(parent = emptyenv())

pbi_auth <- function(tenant = Sys.getenv("PBI_TENANT"),
                     app = Sys.getenv("PBI_APP"),
                     password = Sys.getenv("PBI_PW")) {

  pbi_env$token <- AzureAuth::get_azure_token(
  resource = "https://analysis.windows.net/powerbi/api",
  tenant = Sys.getenv("PBI_TENANT"),
  app = Sys.getenv("PBI_APP"),
  password = Sys.getenv("PBI_PW"),
  auth_type = "client_credentials",
  use_cache = F
  )
}

