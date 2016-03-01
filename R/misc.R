

get_output_index <- function() {
  server_dir <- get_server_dir()
  ff <- list.files(server_dir, pattern = "output.*\\.html")
  if(length(ff) == 0)
    return(1)
  max(as.integer(gsub("output|\\.html", "", ff))) + 1
}

get_output_file <- function(ii) {
  sprintf("output%03d.html", ii)
}

set_index_template <- function() {
  a <- suppressWarnings(readLines(system.file("index.html", package = "rmote")))
  options(rmote_index = paste(a, collapse = "\n"))
}

write_index <- function(ii) {
  if(is.null(getOption("rmote_index")))
    set_index_template()
  res <- gsub("___max_page___", ii, getOption("rmote_index"))
  cat(res, file = file.path(get_server_dir(), "index.html"))
}
