#' Get a document from Google Cloud Firestore
#'
#' @param project - the GCP project
#' @param database - The firestore database default = (default)
#' @param collection - Document collection in the data base..
#' @param document  - Document that you are retrieving.
#'
#' @return the json document.
#' @export
#'
fiRstore_get_document <- function(project,database="(default)",collection,document){
  token <- fiRstore_auth()
  base_url = "https://firestore.googleapis.com/"
  ## make sure project,collection, and document are defined...
  params <- list(project=project,database=database,collection=collection,document=document)
  print(params)

  path = "v1/projects/{project}/databases/{database}/documents/{collection}/{document}"
  print("11111")
  req <- gargle::request_build(method="GET",path=path,params = params,token = token, base_url = base_url)
  print("....")
  resp <- gargle::request_make(req)
  out <- gargle::response_process(resp)

  jsonlite::toJSON(out,pretty = T)
}

## Coming soon:
## https://cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/batchGet
### getDocuments (batchGet) ...
## https://cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/runQuery
### runQuery
## https://cloud.google.com/firestore/docs/reference/rest/v1/projects.databases.documents/listDocuments
### listDocuments

