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
#' @param basegraphics (logical) send base graphics to servr
#' @param htmlwidgets (logical) send htmlwidgets to servr
#' @param hostname (logical) try to get hostname and use it in viewer page title
#'
#' @export
#' @importFrom servr httd
start_rmote <- function(
  server_dir = file.path(tempdir(), "rmote_server"),
  port = 4321, daemon = TRUE,
  help = TRUE, graphics = TRUE,
  basegraphics = TRUE, htmlwidgets = TRUE,
  hostname = TRUE) {

  if(!file.exists(server_dir))
    dir.create(server_dir, recursive = TRUE, showWarnings = FALSE)

  options(rmote_server_dir = server_dir)
  options(rmote_server_port = port)
  options(rmote_help = help)
  options(rmote_graphics = graphics)
  options(rmote_htmlwidgets = htmlwidgets)
  options(rmote_basegraphics = basegraphics)
  options(rmote_hostname = hostname)

  set_index_template()

  if(basegraphics)
    set_base_plot_hook()

  try(servr::httw(server_dir, pattern = "index.html", port = port,
      daemon = daemon, browser = FALSE), silent = TRUE)
}

#' Stop an rmote server
#' @export
stop_rmote <- function() {
  plot_done()
  if(getOption("rmote_basegraphics", FALSE))
    unset_base_plot_hook()
  options(rmote_on = FALSE)
  servr::daemon_stop()
}

#' Set the rmote mode to be on
#'
#' @param server_dir directory where rmote server is running
#' @param help (logical) send results of `?` to servr
#' @param graphics (logical) send traditional lattice / ggplot2 plots to servr
#' @param basegraphics (logical) send base graphics to servr
#' @param htmlwidgets (logical) send htmlwidgets to servr
#' @param hostname (logical) try to get hostname and use it in viewer page title
#' @note This is useful when running multiple R sessions on a server, where all will serve the same rmote process.  It is not necessary to call this in the same session on which \code{\link{start_rmote}} has been called, but on any other R sessions.
#' @export
rmote_on <- function(server_dir,
  help = TRUE, graphics = TRUE,
  basegraphics = TRUE, htmlwidgets = TRUE,
  hostname = TRUE
) {

  if(!file.exists(server_dir))
    stop("The location of server_dir does not exist - no rmote server running here...")

  options(rmote_on = TRUE)

  options(rmote_server_dir = server_dir)
  options(rmote_help = help)
  options(rmote_graphics = graphics)
  options(rmote_htmlwidgets = htmlwidgets)
  options(rmote_basegraphics = basegraphics)
  options(rmote_hostname = hostname)

  if(basegraphics)
    set_base_plot_hook()

  invisible(NULL)
}

#' Set the rmote mode to be off
#'
#' @export
rmote_off <- function() {
  plot_done()
  if(getOption("rmote_basegraphics", FALSE))
    unset_base_plot_hook()
  options(rmote_on = FALSE)
}
