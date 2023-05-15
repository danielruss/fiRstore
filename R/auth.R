.auth <- gargle::init_AuthState(
  package     = "fiRstore",
  auth_active = TRUE
  # app = NULL,
  # api_key = NULL,
  # cred = NULL
)


#' Configure application for fiRstore
#' @description
#' Configures the httr oauth application.
#' Gargle formerly used [httr::oauth_app]
#' but is transitioning to [httr2::oauth_client].
#' The fiRstore package is following the other packages such as
#' bigrquery by having an auth_configure function that takes
#' a path and uses an [httr2::oauth_client].
#'
#'
#' @param app
#' an httr oauth application
#'
#' @param path
#' The path to the JSON file containing
#' the client Id/password associated with the GCP
#' project.
#'

#' @note
#' This  change in the future as gargle continues the transition
#' from httr to httr2.
#'
#' @seealso [bigrquery::bq_auth_configure], [googledrive::drive_auth_config],
#' [googledrive::drive_auth_configure]
#' @export
fiRstore_auth_config<-function(app){
  .auth$set_app(app)
}

#' @rdname fiRstore_auth_config
#' @export
#'
fiRstore_auth_configure <- function(path){
  .auth$set_app( gargle::gargle_oauth_client_from_json(path) )
}

#' gets the fiRstore application
#'
#'.This will change in the future to match the googledrive package.
#'
#' @export

fiRstore_auth_app <-function(){
  .auth$app
}

#' Authorize fiRstore
#'
#' @description
#' Authorizes fiRstore to access documents in Google Firestore.  This function
#' is a wrapper around [gargle::token_fetch()].
#'
#' The package does not supply a default application, so you will need to provide
#' an application by calling fiRstore_auth_config(app = your_app).  To create
#' an application call [httr::oauth_app()]
#'
#' @param email - Google identity of the user
#' @param path - JSON key file for a service account user.
#' @param scopes - Additional permissions associated with the token
#' @param cache - OAuth token cache.
#' @param use_oob - Are you using the out-of-band authentication
#' @param token - a prepared token (not sure why this is here,
#'  maybe I already have a token ... see [gargle::token_fetch()] for more info)
#'
#' @return Returns an invisible token.
#'
#' @export
#'
fiRstore_auth<-function(email = gargle::gargle_oauth_email(),
                         path = NULL,
                         scopes = "https://www.googleapis.com/auth/datastore",
                         cache = gargle::gargle_oauth_cache(),
                         use_oob = gargle::gargle_oob_default(),
                         token = NULL){
  if (.auth$has_cred()) return(.auth$cred)

  if (is.null(fiRstore_auth_app())){
    stop("FiRstore requires an oauth app specific for the project. \n Call fiRstore_auth_config()")
  }
  cred <- gargle::token_fetch(
    scopes = scopes,
    app = fiRstore_auth_app(),
    email = email,
    path = path,
    cache = cache,
    use_oob = use_oob,
    token = token
  )

  .auth$set_cred(cred)
  .auth$set_auth_active(TRUE)

  invisible(cred)
}
