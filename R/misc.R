#' Initialize a remote servr
#'
#' @param server_dir directory to launch servr from
#' @param port port to run servr on
#' @param help (logical) send results of `?` to servr
#' @param raster (logical) send lattice / ggplot2 plots to servr
#' @param htmlwidgets (logical) send htmlwidgets to servr
#'
#' @export
#' @importFrom servr httd
rmote_server_init <- function(server_dir = file.path(tempdir(), "rmote_server"),
  port = 4321, help = TRUE, raster = TRUE, htmlwidgets = TRUE) {

  if(!file.exists(server_dir))
    dir.create(server_dir, recursive = TRUE, showWarnings = FALSE)

  options(rmote_server_dir = server_dir)
  options(rmote_server_port = port)
  options(rmote_help = help)
  options(rmote_raster = raster)
  options(rmote_htmlwidgets = htmlwidgets)

  try(servr::httd(server_dir, port = port,
      daemon = TRUE, browser = FALSE), silent = TRUE)
}

get_server_dir <- function() {
  server_dir <- getOption("rmote_server_dir")
  if(is.null(server_dir))
    stop("No setting for rmote_server_dir - make sure to call rmote_server_init()")

  if(!file.exists(server_dir))
    dir.create(server_dir, recursive = TRUE, showWarnings = FALSE)

  server_dir
}

get_port <- function() {
  port <- getOption("rmote_server_port")
  if(is.null(port))
    stop("No setting for rmote_server_port - make sure to call rmote_server_init()")

  port
}

random_pad <- function() {
  pad <- paste(rep("", sample(1:200, 1)), collapse = "\n")
  cat(pad, file = file.path(get_server_dir(), "index.html"), append = TRUE)
}
