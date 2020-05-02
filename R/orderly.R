##' Create an orderly remote based on sharepoint
##'
##' @title Create an orderly remote based on sharepoint
##' @param url Sharepoint URL
##' @param site Sharepoint "site"
##' @param path Path within the sharepoint site
##' @return An \code{orderly_remote_sharepoint} object
##' @export
orderly_remote_sharepoint <- function(url, site, path) {
  client <- orderly_sharepoint_client(url)
  folder <- orderly_sharepoint_folder(client, site, path)
  orderly_remote_sharepoint_$new(folder)
}


## Seems hard to mock the whole class out, which I think validates my
## general approach of exposing free constructor!
## https://github.com/r-lib/mockery/issues/21
orderly_sharepoint_client <- function(url) {
  pointr::pointr$new(url) # nocov
}


orderly_sharepoint_folder <- function(client, site, path) {
  folder <- tryCatch(
    client$folder(site, path, verify = TRUE),
    error = function(e)
      stop(sprintf("Error reading from %s:%s - %s",
                   site, path, e$message), call. = FALSE))
  path <- "orderly.sharepoint"
  exists <- tryCatch({
    folder$download(path)
    TRUE
  }, error = function(e) FALSE)
  if (exists) {
    return(folder)
  }
  if (nrow(folder$list()) > 0L) {
    stop(sprintf(
      "Directory %s:%s cannot be used for orderly; contains other files",
      site, path))
  }
  tmp <- tempfile()
  on.exit(unlink(tmp))
  writeLines("orderly.sharepoint", tmp)
  folder$upload(tmp, path)
  folder
}


orderly_remote_sharepoint_ <- R6::R6Class(
  "orderly_remote_sharepoint",
  cloneable = FALSE,

  public = list(
    folder = NULL,

    initialize = function(folder) {
      self$folder <- folder
    },

    list_reports = function() {
      sort(self$folder$folders("archive")$name)
    },

    list_versions = function(name) {
      sort(self$folder$files(file.path("archive", name))$name)
    },

    push = function(path) {
      path_meta <- file.path(path, "orderly_run.rds")
      stopifnot(file.exists(path_meta))

      zip <- tempfile(fileext = ".zip")
      zip_dir(path, zip)
      on.exit(unlink(zip))

      dat <- readRDS(path_meta)
      name <- dat$meta$name
      id <- dat$meta$id

      self$folder$create(file.path("archive", name))
      self$folder$upload(zip, file.path("archive", name, id))
    },

    pull = function(name, id) {
      zip <- tempfile(fileext = ".zip")
      on.exit(unlink(zip))
      zip <- self$folder$download(file.path("archive", name, id), zip)
      unzip_archive(zip, name, id)
    },

    run = function(...) {
      stop("'orderly_remote_sharepoint' remotes do not run")
    },

    url_report = function(name, id) {
      stop("'orderly_remote_sharepoint' remotes do not support urls")
    }
  ))
