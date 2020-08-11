#' Reset the notebook directory to the last git commit
#'
#' This function checks out the last git commit for the notebook folder. By
#' default, it throws an error if there are uncommitted .rmd files. This is a
#' dangerous function. Proceed with caution.
#'
#' @param path notebook folder. Defaults to `"notebook"`.
#' @param force whether to discard uncommited .rmd files. Defaults to `FALSE`.
#' @return `NULL`. The function is called for its effects on the project files.
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
  invisible(NULL)
}


#' Preview the current notebook
#'
#' `notebook_browse()` opens the current notebook in a browser.
#' `notebook_peek()` copies the notebook to a temporary file and opens it in the
#' RStudio Viewer pane.
#'
#' @rdname notebook_browse
#' @param file path to the current notebook file. Defaults to
#'   `"notebook/docs/notebook.html"`
#' @return `NULL`. The function is called for its effects on the project files.
#' @export
notebook_browse <- function(file = "notebook/docs/notebook.html") {
  browseURL(file)
  invisible(NULL)
}

#' @rdname notebook_browse
#' @export
notebook_peek <- function(file = "notebook/docs/notebook.html") {
  out <- file.path(tempdir(), basename(file))
  file.copy(file, out, overwrite = TRUE)
  rstudioapi::viewer(out)
  invisible(NULL)
}
