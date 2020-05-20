
#' @export
notebook_reset <- function(path = "notebook", force = FALSE) {
  uses_git <- dir.exists(".git")

  if (!uses_git) {
    usethis::ui_stop(
      "{usethis::ui_code('notebook_reset()')} only works with git repositories"
    )
  }

  repo <- git2r::repository(".")
  uncommitted <- fs::path(unname(unlist(git2r::status())))

  in_notebook <-
    uncommitted[unlist(lapply(uncommitted, fs::path_has_parent, path))]
  rmds_in_notebook <- in_notebook[tolower(fs::path_ext(in_notebook)) == "rmd"]

  if (length(rmds_in_notebook) > 0 && force == FALSE) {
    usethis::ui_stop(
      "Uncommitted Rmd files: {usethis::ui_path(rmds_in_notebook)}"
    )
  }

  usethis::ui_info(
    "Deleting uncommitted files in {usethis::ui_path(path)}"
  )
  unlink(in_notebook, recursive = TRUE)

  usethis::ui_info(
    "Resetting {usethis::ui_path(path)} folder to last commit"
  )
  git2r::checkout(repo, path = path)
}

#' @export
notebook_browse <- function(url = "notebook/docs/notebook.html") {
  browseURL(url)
}

#' @export
notebook_peek <- function(file = "notebook/docs/notebook.html") {
  out <- file.path(tempdir(), basename(file))
  file.copy(file, out, overwrite = TRUE)
  rstudioapi::viewer(out)
}

