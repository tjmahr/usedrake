#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL


#' @export
use_drake_notebook <- function(path = ".") {
  here::set_here(path)
  usethis::local_project(path = path, quiet = TRUE)

  # Layout the groundwork for future customizability
  notebook_dir <- "notebook"
  notebook_file <- function(x) {
    file.path(notebook_dir, x)
  }

  usethis::use_directory("R")
  usethis::use_directory("data")
  usethis::use_directory(notebook_dir)
  usethis::use_directory(notebook_file("assets"))

  usethis::use_template("packages.R", "R/packages.R", package = "usedrake")
  usethis::use_template("notebook/plan.R", "R/plan.R", package = "usedrake")
  usethis::use_template("functions.R", "R/functions.R", package = "usedrake")

  usethis::use_template(
    "notebook/index.Rmd",
    notebook_file("index.Rmd"),
    package = "usedrake"
  )
  usethis::use_template(
    "notebook/knitr-helpers.R",
    notebook_file("knitr-helpers.R"),
    package = "usedrake"
  )
  usethis::use_template(
    "notebook/0000-00-00-references.Rmd",
    notebook_file("0000-00-00-references.Rmd"),
    package = "usedrake"
  )

  usethis::use_template("_drake.R", package = "usedrake")
  usethis::use_template("Makefile", package = "usedrake")

  create_notebook_page(notebook_dir = notebook_dir, open = TRUE)

  usethis::ui_todo(
    paste(
      "Set",
      usethis::ui_field("Project Options > Build Tools"),
      "to use a Makefile")
  )
}


#' @export
create_notebook_page <- function(
  slug = NULL,
  date = NULL,
  notebook_dir = "notebook",
  open = TRUE
) {
  if (is.null(date)) {
    date_data <- Sys.Date()
    date <- format(date_data, "%Y-%m-%d")
  } else {
    date_data <- as.Date(date, "%Y-%m-%d")
  }

  data_title_month <- format.Date(date_data, "%b. ")
  data_title_day <- as.integer(format.Date(date_data, "%d"))
  data_title_year <- format.Date(date_data, ", %Y")
  date_title <- paste0(data_title_month, data_title_day, data_title_year)

  if (is.null(slug)) {
    slug <- ""
    sep <- ""
  } else {
    sep <- "-"
  }
  filename <- paste0(date, sep, slug, ".Rmd")

  to_create <- file.path(notebook_dir, filename)

  usethis::use_template(
    "notebook/0000-00-00-demo-post.Rmd",
    to_create,
    package = "usedrake",
    data = list(date = date_title),
    open = open
  )

  usethis::ui_done("{usethis::ui_path(to_create)} created")
  # message(to_create, " created")
}

#' @export
datestamp_current_notebook <- function(
  notebook_dir  = "notebook",
  notebook_file = "notebook.html",
  new_file_slug = "notebook"
) {
  old_path <- file.path(notebook_dir, "docs", notebook_file)

  if (!file.exists(old_path)) {
    usethis::ui_stop("File does not exist: {usethis::ui_path(old_path)}")
  }

  datestamp <- format(Sys.Date(), "%Y-%m-%d")
  ext <- tools::file_ext(notebook_file)

  new_file <- paste0(datestamp, "-", new_file_slug, ".", ext)

  new_path <- file.path(notebook_dir, "docs", new_file)


  if (file.exists(new_path)) {
    usethis::ui_info("Overwriting file: {usethis::ui_path(new_path)}")
  }

  success <- file.copy(old_path, new_path, overwrite = TRUE)

  if (success) {
    usethis::ui_done(
      "{usethis::ui_path(old_path)} copied to {usethis::ui_path(new_path)}"
    )
  }
  invisible(success)
}