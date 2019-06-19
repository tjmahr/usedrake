# This file serves the r_*() functions (e.g. r_make()) described at
# https://ropenscilabs.github.io/drake-manual/projects.html#safer-interactivity

# # If you have problems with special characters being corrupted by source(),
# # try this alternative.
# source_utf8 <- function(f) {
#   l <- readLines(f, encoding = "UTF-8")
#   eval(parse(text = l, encoding = "UTF-8"), envir = .GlobalEnv)
# }

# Load our packages and supporting functions into our session.
source(here::here("R/packages.R"))
source(here::here("R/functions.R"))

# Create the `drake` plan that outlines the work we are going to do.
source(here::here("R/plan.R"))

# _drake.R must end with a call to `drake_config()`
drake_config(plan)

# Use this if Stan models have trouble running in drake
# drake_config(plan, lock_envir = FALSE)
