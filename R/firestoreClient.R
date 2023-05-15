#' Get a document from Google Cloud Firestore
#'
#' @description
#' Wraps the [GCP Firestore get REST API](https://firebase.google.com/docs/firestore/reference/rest/v1/projects.databases.documents/get)
#'
#'
#' @param project - the GCP project
#' @param database - The firestore database default = (default)
#' @param collection - Document collection in the data base..
#' @param document  - Document that you are retrieving.
#'
#' @return the json document.
#' @export
#'
fiRstore_get <- function(project,database="(default)",collection,document){
  token <- fiRstore_auth()
  base_url = "https://firestore.googleapis.com/"
  ## make sure project,collection, and document are defined...
  params <- list(project=project,database=database,collection=collection,document=document)
  print(params)

  path = "v1/projects/{project}/databases/{database}/documents/{collection}/{document}"
  req <- gargle::request_build(method="GET",path=path,params = params,token = token, base_url = base_url)
  resp <- gargle::request_make(req)
  out <- gargle::response_process(resp)

  jsonlite::toJSON(out,pretty = T)
}

#' Search for documents in GCP cloud Firestore
#'
#' @description
#' Runs a query and returns the documents
#' Wraps the [GCP Firestore runQueryr REST API](https://firebase.google.com/docs/firestore/reference/rest/v1/projects.databases.documents/runQuery)
#'
#' @param project the GCP project
#' @param database The firestore database default = (default)
#' @param collection Document collection in the data base..
#' @param query  JSON text
#'
#' An example query would look like this
#' "{\"structuredQuery\":{\"from\":[{\"collectionId\":\"people\",\"allDescendants\":false}],\"where\":{\"fieldFilter\":{\"field\":{\"fieldPath\":\"FirstName\"},\"op\":\"EQUAL\",\"value\":{\"stringValue\":\"Daniel\"}}}}}"
#'
#' @return JSON text containing the results of the query
#' @export
#'
fiRstore_runQuery <- function(project,database="(default)",collection,query){
  token <- fiRstore_auth()
  base_url = "https://firestore.googleapis.com/"
  ## make sure project,collection, and document are defined...
  params <- list(project=project,database=database)
  path = "v1/projects/{project}/databases/{database}/documents:runQuery"
  req <- gargle::request_build(method="POST",path=path,params = params,body=query,token = token, base_url = base_url)

  resp <- gargle::request_make(req)
  out <- gargle::response_process(resp)

  jsonlite::toJSON(out,pretty=T,auto_unbox = T)
}

## Coming soon:
## https://cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/batchGet
### getDocuments (batchGet) ...
## https://cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/runQuery
### runQuery
## https://cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/listDocuments
### listDocuments

