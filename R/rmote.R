#' @import ggplot2
#' @import lattice
#' @import htmlwidgets
NULL

#' Initialize a remote servr
#'
#' @param server_dir directory to launch servr from
#' @param port port to run servr on
#' @param daemon logical - should the server be started as a daemon?
#' @param help (logical) send results of `?` to servr
#' @param graphics (logical) send traditional lattice / ggplot2 plots to servr
#' @param htmlwidgets (logical) send htmlwidgets to servr
#'
#' @export
#' @importFrom servr httd
start_rmote <- function(server_dir = file.path(tempdir(), "rmote_server"),
  port = 4321, daemon = TRUE,
  help = TRUE, graphics = TRUE, htmlwidgets = TRUE) {

  if(!file.exists(server_dir))
    dir.create(server_dir, recursive = TRUE, showWarnings = FALSE)

  options(rmote_server_dir = server_dir)
  options(rmote_server_port = port)
  options(rmote_help = help)
  options(rmote_graphics = graphics)
  options(rmote_htmlwidgets = htmlwidgets)
  set_index_template()

  try(servr::httw(server_dir, pattern = "index.html", port = port,
      daemon = daemon, browser = FALSE), silent = TRUE)
}

#' Stop an rmote server
#' @export
stop_rmote <- function() {
  servr::daemon_stop()
}

#' Set the rmote mode to be on
#'
#' @param server_dir directory where rmote server is running
#' @param help (logical) send results of `?` to servr
#' @param graphics (logical) send traditional lattice / ggplot2 plots to servr
#' @param htmlwidgets (logical) send htmlwidgets to servr
#' @note This is useful when running multiple R sessions on a server, where all will serve the same rmote process.  It is not necessary to call this in the same session on which \code{\link{start_rmote}} has been called, but on any other R sessions.
#' @export
rmote_on <- function(server_dir,
  help = TRUE, graphics = TRUE, htmlwidgets = TRUE
) {

  if(!file.exists(server_dir))
    stop("The location of server_dir does not exist - no rmote server running here...")

  options(rmote_on = TRUE)

  options(rmote_server_dir = server_dir)
  options(rmote_help = help)
  options(rmote_graphics = graphics)
  options(rmote_htmlwidgets = htmlwidgets)

  invisible(NULL)
}

#' Set the rmote mode to be off
#'
#' @export
rmote_off <- function() {
  options(rmote_on = FALSE)
}

is_rmote_on <- function() {
  getOption("rmote_on", FALSE) || length(servr::daemon_list()) > 0
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

