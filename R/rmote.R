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
#' This is useful if there is another R session on the server with an rmote server running that the current session would like to make use of.
#'
#' @param on should rmote act as if the rmote server is on?
#' @param server_dir directory where rmote server is running
#' @param help (logical) send results of `?` to servr
#' @param graphics (logical) send traditional lattice / ggplot2 plots to servr
#' @param htmlwidgets (logical) send htmlwidgets to servr
#' @note This is useful when rmote is serving from a
rmote_mode <- function(on = TRUE,
  server_dir = file.path(tempdir(), "rmote_server"),
  help = TRUE, graphics = TRUE, htmlwidgets = TRUE
) {

  options(rmote_on = on)

  if(on) {
    options(rmote_server_dir = server_dir)
    options(rmote_help = help)
    options(rmote_graphics = graphics)
    options(rmote_htmlwidgets = htmlwidgets)
  }

  invisible(NULL)
}

rmote_on <- function() {
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

