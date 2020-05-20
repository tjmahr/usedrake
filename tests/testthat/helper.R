# Adapted from Jenny Bryan's tutorial
# https://www.tidyverse.org/blog/2020/04/self-cleaning-test-fixtures/
create_local_project <- function(dir = fs::file_temp(), env = parent.frame()) {
  old_project <- usethis::proj_get()    # --- Record starting state ---

  withr::defer({
    # --- Defer The Undoing ---
    # restore active usethis project (-C)
    usethis::proj_set(old_project, force = TRUE)
    # restore working directory      (-B)
    setwd(old_project)
    # delete the temporary package   (-A)
    fs::dir_delete(dir)
  }, envir = env)

  # --- Do The Doing ---

  # create new folder and package  (A)
  usethis::create_project(dir, open = FALSE)
  # change working directory       (B)
  setwd(dir)
  # switch to new usethis project  (C)
  usethis::proj_set(dir)
  invisible(dir)
}
