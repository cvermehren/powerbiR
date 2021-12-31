.pbi_env <- new.env(parent = emptyenv())

#' Authenticate your Power BI API session
#'
#' Run this function at start to obtain an authentication token and save it to
#' the session.
#'
#' @param tenant Your Microsoft tenant ID
#' @param app Your Microsoft app ID
#' @param password Your Microsoft app password (client secret)
#'
#' @details
#' To auto-authenticate, you can specify credentials in environment variables
#' via an \env{.Renviron} file or using \code{\link{Sys.setenv}} (see example below).
#'
#' This function is a wrapper for AzureAuth::get_azure_token(). Currently, only
#' non-interactive authentication is supported. You need to register an Azure
#' Active Directory service-principal application and obtain tenant ID, app ID
#' and app password (client secret).
#'
#' For reasons of CRAN policy, the first time AzureAuth is loaded, it will
#' prompt you for permission to create a user-specific directory in order to
#' cache the token. The prompt only appears in an interactive session, not in a
#' batch script. For more details, see
#' \href{https://github.com/cloudyr/AzureAuth}{AzureAuth}.
#'
#' @return Invisibly, the token that has been saved to the session.
#' @export
#' @examples
#'
#' \dontrun{
#' # Set token in environment
#' Sys.setenv(
#'   PBI_TENANT = "my_tenant_id",
#'   PBI_APP = "my_app_id",
#'   PBI_PW = "my_app_client_secret"
#'   )
#'
#'   pbi_auth()
#' }
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

