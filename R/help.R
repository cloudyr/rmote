
#' Print help page to servr
#'
#' @param x help object
#' @param \ldots  additional parameters
#' @S3method print help_files_with_topic
#' @importFrom tools Rd2HTML
print.help_files_with_topic <- function(x, ...) {

  file <- as.character(x)

  help_opt <- getOption("rmote_help", FALSE)

  if(is_rmote_on() && help_opt && length(file) == 1 && grepl("/help/", file)) {
    message("serving help through rmote")

    res <- try({
      topic <- gsub(".*/help/(.*)", "\\1", file)
      package <- gsub(".*/(.*)/help/.*", "\\1", file)
      rdb_path <- file.path(system.file("help", package = package), package)
      tmp <- getFromNamespace("fetchRdDB", "tools")(rdb_path, topic)
      capture.output(tools::Rd2HTML(tmp))
    }, silent = TRUE)
    if(!inherits(res, "try-error")) {
      server_dir <- get_server_dir()
      # move R.css over
      # file.path(R.home('doc'), 'html', 'R.css')
      if(!file.exists(file.path(server_dir, "R.css")))
        file.copy(file.path(system.file(package = "rmote"), "R.css"), server_dir)

      ii <- get_output_index()
      writeLines(c("<!-- DISABLE-SERVR-WEBSOCKET -->", res),
        file.path(server_dir, get_output_file(ii)))
      write_index(ii)
      return()
    }
  } else {
    getFromNamespace("print.help_files_with_topic", "utils")(x)
  }
}
