#' @keywords internal
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
## usethis namespace: end
NULL

use_drake <- function(path = ".", open = FALSE) {
  here::set_here(path)
  usethis::local_project(path = path, quiet = TRUE)

  usethis::use_directory("R")
  usethis::use_directory("data")
  usethis::use_directory("analysis")

  usethis::use_template(
    "packages.R",
    "R/packages.R",
    package = "usedrake",
    open = open
  )
  usethis::use_template(
    "plan.R",
    "R/plan.R",
    package = "usedrake",
    open = open
  )
  usethis::use_template(
    "functions.R",
    "R/functions.R",
    package = "usedrake",
    open = open
  )

  usethis::use_template(
    "example.Rmd",
    "analysis/example.Rmd",
    package = "usedrake",
    open = open
  )


  usethis::use_template("_drake.R", package = "usedrake")
  usethis::use_template("Makefile", package = "usedrake")

  usethis::ui_todo(
    paste(
      "Set",
      usethis::ui_field("Project Options > Build Tools"),
      "to use a Makefile")
  )
}
