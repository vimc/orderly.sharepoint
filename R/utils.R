`%||%` <- function(x, y) {
  if (is.null(x)) y else x
}


zip_dir <- function(path, dest = paste0(basename(path), ".zip")) {
  withr::with_dir(dirname(path), {
    zip::zipr(dest, basename(path))
    normalizePath(dest)
  })
}
