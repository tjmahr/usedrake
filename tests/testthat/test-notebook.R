test_that("dropping in notebook templates", {
  dir <- create_local_project()

  use_drake_notebook()
  expect_true(file.exists("_drake.R"))
  expect_true(file.exists(".here"))
  expect_true(file.exists("Makefile"))

  expect_true(file.exists("R/packages.R"))
  expect_true(file.exists("R/plan.R"))
  expect_true(file.exists("R/functions.R"))

  expect_true(file.exists("notebook/index.Rmd"))
  expect_true(file.exists("notebook/0000-00-00-references.Rmd"))
  expect_true(file.exists("notebook/knitr-helpers.R"))
})

test_that("building the notebook", {
  dir <- create_local_project()

  use_drake_notebook()
  capture.output(drake::r_make())

  history <- drake::drake_history()
  expect_true(all(history$current))
})

test_that("creating additional files", {
  dir <- create_local_project()

  use_drake_notebook()

  # New page
  create_notebook_page("test-post", date = "2020-01-01", open = FALSE)
  expect_true(file.exists("notebook/2020-01-01-test-post.Rmd"))

  # New page renders
  capture.output(drake::r_make())
  expect_true(file.exists("notebook/docs/2020-01-01-test-post.md"))

  # Backing up notebook
  datestamp_current_notebook(new_file_slug = "backup")
  expect_true(file.exists(Sys.glob("notebook/docs/*-backup.html")))
})
