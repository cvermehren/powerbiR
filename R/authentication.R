.pbi_env <- new.env(parent = emptyenv())
.pbi_env$token$credentials <- NULL

#.pbi_env$token <- NULL

#' Authenticate your Power BI API session
#'
#' Run this function at start to authenticate your session. An authentication
#' token is returned invisibly and used by other functions while requesting the
#' Power BI API. The token is automatically refreshed upon expiration.
#'
#' @param tenant Your Microsoft tenant ID
#' @param app Your Microsoft app ID
#' @param password Your Microsoft app password (client secret)
#'
#' @details
#' To auto-authenticate, you can specify credentials in environment variables
#' via an \env{.Renviron} file or using \code{\link{Sys.setenv}} (see example
#' below).
#'
#' pbi_auth() is a wrapper for AzureAuth::get_azure_token(). Currently, only
#' non-interactive authentication is supported. You therefore need to register
#' an Azure Active Directory service-principal application and obtain tenant ID,
#' app ID and app password (client secret).
#'
#' For reasons of CRAN policy, the first time AzureAuth is loaded, it will
#' prompt you for permission to create a user-specific directory in order to
#' cache the token. The prompt only appears in an interactive session, not in a
#' batch script. For more details, see
#' \href{https://github.com/cloudyr/AzureAuth}{AzureAuth}.
#'
#' @return Returns a token invisibly.
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
  .pbi_env$token <- try(AzureAuth::get_azure_token(
    resource = "https://analysis.windows.net/powerbi/api",
    tenant = tenant,
    app = app,
    password = password,
    auth_type = "client_credentials",
    use_cache = F
  ))

  if (inherits(.pbi_env$token, "try-error")) {
    stop("Please save your Azure tenant ID, App ID and client secret in an environment variable.\nSee ?pbi_auth() for details.")
    }
}


pbi_get_token <- function() {


  if(length(.pbi_env$token$credentials$expires_on) == 0) {

    res <- try(pbi_auth(), silent = TRUE)

    if(inherits(res, "try-error")) {
      stop("Couldn't find credentials. Please authenticate using pbi_auth()")
    }
  }

  expires_on <- as.numeric(.pbi_env$token$credentials$expires_on)
  stale_token <- lubridate::as_datetime(expires_on) <= Sys.time()

  if (stale_token) {
    futile.logger::flog.info("Refreshing stale token...")
    .pbi_env$token$refresh()
  }

  return(.pbi_env$token$credentials$access_token)
}

