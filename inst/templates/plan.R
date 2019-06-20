# The workflow plan data frame outlines what you are going to do.
plan <- drake_plan(
  data = datasets::iris,

  hist = create_plot(data),
  fit = lm(Sepal.Width ~ Petal.Width + Species, data),

  report = rmarkdown::render(
    knitr_in(here::here("analysis/example.Rmd")),
    output_dir = here::here("analysis"),
    output_file = file_out(here::here("analysis/example.html")),
    quiet = TRUE,
    encoding = "UTF-8"
  ),

  spellcheck_exceptions = c(
    character(0)
  ),

  spellcheck_report = spelling::spell_check_files(
    knitr_in(here::here("analysis/example.Rmd")),
    ignore = spellcheck_exceptions
  ),

  # Prints out spelling mistakes when any are found
  spellcheck_report_results = target(
    command = print(spellcheck_report),
    trigger = trigger(condition = nrow(spellcheck_report) > 0)
  ),
)
