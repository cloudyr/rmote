
get_hostname <- function() {
  hn <- try(system("hostname", intern = TRUE, ignore.stderr = TRUE), silent = TRUE)
  if(inherits(hn, "try-error"))
    hn <- ""
  hn
}

get_output_index <- function() {
  server_dir <- get_server_dir()
  idx_path <- file.path(get_server_dir(), ".idx")
  if(!file.exists(idx_path))
    return(1)
  as.integer(readLines(idx_path, warn = FALSE)[1]) + 1
}

get_output_file <- function(ii) {
  sprintf("output%04d.html", ii)
}

set_index_template <- function() {
  a <- suppressWarnings(readLines(system.file("index.html", package = "rmote")))
  if(getOption("rmote_hostname")) {
    idx <- grepl("rmote viewer", a[1:10])
    hn <- get_hostname()
    if(length(idx) > 0 && hn != "")
      a[idx] <- gsub("rmote viewer", paste("rmote:", hn), a[idx])
  }
  options(rmote_index = paste(a, collapse = "\n"))
}

write_html <- function(html) {
  ii <- get_output_index()
  htmltools::save_html(
    tagList(HTML("<!-- DISABLE-SERVR-WEBSOCKET -->"), html),
    file = file.path(get_server_dir(), get_output_file(ii)))
  write_index(ii)
}

write_index <- function(ii) {
  if(is.null(getOption("rmote_index")))
    set_index_template()
  res <- gsub("___max_page___", ii, getOption("rmote_index"))
  # write out file index
  cat(ii, file = file.path(get_server_dir(), ".idx"))
  cat(res, file = file.path(get_server_dir(), "index.html"))
}

dir.exists <- function(x) {
  if(file.exists(x) & file.info(x)$isdir)
    return(TRUE)
  return(FALSE)
}
