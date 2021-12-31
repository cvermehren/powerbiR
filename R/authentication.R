.pbi_env <- new.env(parent = emptyenv())

#' Authenticate your Power BI API session
#'
#' Supply your application name, client ID and client secret. You will need to
#' register an application here:
#' https://powerbi.microsoft.com/en-us/documentation/powerbi-developer-register-a-web-app/
#'
#' @param tenant Your Microsoft tenant ID
#' @param app Your Microsoft App ID
#' @param password Your Microsoft App password
#'
#' @return An active token
#' @export
pbi_auth <- function(tenant = Sys.getenv("PBI_TENANT"),
                     app = Sys.getenv("PBI_APP"),
                     password = Sys.getenv("PBI_PW")) {

  .pbi_env$token <- AzureAuth::get_azure_token(
  resource = "https://analysis.windows.net/powerbi/api",
  tenant = Sys.getenv("PBI_TENANT"),
  app = Sys.getenv("PBI_APP"),
  password = Sys.getenv("PBI_PW"),
  auth_type = "client_credentials",
  use_cache = F
  )
}

