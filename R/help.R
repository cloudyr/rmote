
#' Print help page to servr
#'
#' @param x help object
#' @param \ldots  additional parameters
#' @export
#' @importFrom tools Rd2HTML
print.help_files_with_topic <- function(x, ...) {
  file <- as.character(x)

  help_opt <- getOption("rmote_help")
  if(is.null(help_opt) || !is.logical(help_opt))
    help_opt <- FALSE

  if(help_opt && length(file) == 1 && grepl("/help/", file)) {
    res <- try({
      topic <- gsub(".*/help/(.*)", "\\1", file)
      package <- gsub(".*/(.*)/help/.*", "\\1", file)
      rdb_path <- file.path(system.file("help", package = package), package)
      capture.output(tools::Rd2HTML(tools:::fetchRdDB(rdb_path, topic)))
    }, silent = TRUE)
    if(!inherits(res, "try-error")) {
      server_dir <- get_server_dir()
      # move R.css and live.js over
      # file.path(R.home('doc'), 'html', 'R.css')
      if(!file.exists(file.path(server_dir, "live/live.js")))
        file.copy(file.path(system.file(package = "rmote"), "live/live.js"), server_dir)
      if(!file.exists(file.path(server_dir, "R.css")))
        file.copy(file.path(system.file(package = "rmote"), "R.css"), server_dir)

      idx <- which(grepl("</head>", res))
      if(length(idx) > 0 && getOption("rmote_use_live", default = FALSE)) {
        res[idx[1]] <- gsub("(.*)</head>(.*)", "\\1\n<script type='text/javascript' src='live.js'></script>\n</head>\\2", res[idx[1]])
      }
      writeLines(res, file.path(server_dir, "index.html"))
      return()
    }
  }
  utils:::print.help_files_with_topic(x)
}


