#' Get and commit the data from the spreadsheet to the git repository.
#'
#' Usage
#' -----
#'
#'   $ Rscript get-data.R
#'   $ git push
#'
#' Changelog
#' ---------
#'
#' - 2020-03-30
#'   + styler this file
#'   + Intial draft
#'   + Repository created
#'
#'
library(googlesheets4)
library(git2r)

sheets_auth()
if (!sheets_has_token()) {
  stop("Could not authenticate session!")
}


google_sheets <- list(
  raw_data = list(
    url = "https://docs.google.com/spreadsheets/d/1F6_6k3i7u1OhehMcCBRUT-u3qgiiZw_9hmLaFeDcqYM/edit#gid=0",
    name = "raw-data"
  ),
  data_dictionary = list(
    url = "https://docs.google.com/spreadsheets/d/1F6_6k3i7u1OhehMcCBRUT-u3qgiiZw_9hmLaFeDcqYM/edit#gid=1588725591",
    name = "data-dictionary"
  ),
  task_list = list(
    url = "https://docs.google.com/spreadsheets/d/1F6_6k3i7u1OhehMcCBRUT-u3qgiiZw_9hmLaFeDcqYM/edit#gid=1278748631",
    name = "task-list"
  ),
  wikipedia_table = list(
    url = "https://docs.google.com/spreadsheets/d/1F6_6k3i7u1OhehMcCBRUT-u3qgiiZw_9hmLaFeDcqYM/edit#gid=1633099878",
    name = "wikipedia-table"
  ),
  resources = list(
    url = "https://docs.google.com/spreadsheets/d/1F6_6k3i7u1OhehMcCBRUT-u3qgiiZw_9hmLaFeDcqYM/edit#gid=1649165585",
    name = "resources"
  ),
  contributors = list(
    url = "https://docs.google.com/spreadsheets/d/1F6_6k3i7u1OhehMcCBRUT-u3qgiiZw_9hmLaFeDcqYM/edit#gid=697445461",
    name = "contributors"
  )
)

output_dir <- "sheet_archive"
if (!dir.exists(output_dir)) {
  stop("Output directory does not exist!")
}

curr_date <- Sys.Date()
for (sheet in google_sheets) {
  x <- read_sheet(sheet$url, col_types = "c")
  output_filepath <- sprintf("%s/%s-%s.csv", output_dir, sheet$name, curr_date)
  if (file.exists(output_filepath)) {
    stop(sprintf("The file already exists: %s", output_filepath))
  }
  write.csv(x, output_filepath, row.names = FALSE)
}


add(path = sprintf("%s/*%s.csv", output_dir, curr_date))
commit(message = "automatic commit of the sheet data")

cat("\n\nREMEMBER TO PUSH THESE CHANGES PLEASE :) :)\n\n")
