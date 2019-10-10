# The workflow plan data frame outlines what you are going to do.
plan <- drake_plan(
  data = datasets::iris,

  hist = create_plot(data),
  fit = lm(Sepal.Width ~ Petal.Width + Species, data),

  # bookdown uses yaml configuration files to set options for the package.
  # We want to keep the configuration close to the build workflow, so I have
  # drake create the files using the ymlthis package.
  #
  # glue::glue() ignores the leading spaces from code-formatting.
  notebook_output_yaml_data = ymlthis::yml_empty() %>%
    ymlthis::yml_output(
      bookdown::markdown_document2(
        base_format = "cleanrmd::html_document_clean",
        theme = "water",
        toc = TRUE
      )
    ) %>%
    ymlthis::yml_chuck("output"),

  notebook_output_yaml_file = yaml::write_yaml(
    notebook_output_yaml_data,
    file_out(here::here("notebook/_output.yml"))
  ),

  # Find the chapters and put them in reverse-chronological order
  notebook_path_chapters = here::here(
    "notebook",
    rev(list.files(file_in(here::here("notebook")), "\\d.+.Rmd"))
  ),
  notebook_path_index = here::here("notebook", "index.Rmd"),
  notebook_path_all = c(notebook_path_index, notebook_path_chapters),

  # The chapters are configured in the _bookdown.yml file.
  notebook_bookdown_yaml_data = ymlthis::yml_empty() %>%
    ymlthis::yml_bookdown_opts(
      book_filename = "notebook",
      output_dir = "docs",
      delete_merged_file = TRUE,
      new_session = TRUE,
      before_chapter_script = "knitr-helpers.R",
      rmd_files = basename(notebook_path_all),
    ),

  notebook_bookdown_yaml_file = yaml::write_yaml(
    notebook_bookdown_yaml_data,
    file_out(here::here("notebook/_bookdown.yml"))
  ),

  # drake runs commands to build targets, and we tell it file dependencies using
  # flags like `file_in()`. The code that actually builds the notebook doesn't
  # use any filenames in its arguments. The file dependencies are defined by
  # conventions ("look for an _output.yml file and an index.Rmd file in this
  # directory") or they are defined inside of configuration files (e.g., the
  # chapter collation order is defined in _bookdown.yml). Thus, the file
  # dependencies cannot be deduced from the command. So I create a command using
  # an immediately-invoked function expression (IIFE).
  # <https://en.wikipedia.org/wiki/Immediately_invoked_function_expression> It
  # lets me write out the file dependencies manually alongside the code to build
  # the notebook. That way, the file dependencies have to be up to date before
  # rendering the notebook
  notebook = (function() {
    # Tell drake to find and check all the input files of the notebook
    knitr_in(
      !! here::here(
        "notebook",
        list.files(here::here("notebook"), "(index.Rmd)|(\\d.+.Rmd)")
      )
    )
    # file_in(here::here("notebook/assets/apa.csl"))
    # file_in(here::here("notebook/assets/refs.bib"))
    file_in(here::here("notebook/knitr-helpers.R"))
    file_in(here::here("notebook/_bookdown.yml"))
    file_in(here::here("notebook/_output.yml"))
    rmarkdown::render_site("notebook", encoding = 'UTF-8')
    file_out(here::here("notebook/docs/notebook.html"))
  })(),


  spellcheck_exceptions = c(
    character(0)
  ),

  spellcheck_notebook = spelling::spell_check_files(
    file_in(
      !! here::here(
        "notebook",
        list.files(here::here("notebook"), "(index.Rmd)|(\\d.+.Rmd)")
      )
    ),
    ignore = spellcheck_exceptions
  ),

  # Prints out spelling mistakes when any are found
  spellcheck_report_results = target(
    command = print(spellcheck_notebook),
    trigger = trigger(condition = nrow(spellcheck_notebook) > 0)
  ),

)
