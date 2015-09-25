#' Print trellis plot to servr
#'
#' @param x trellis object
#' @param \ldots  additional parameters
#' @export
#' @import htmltools
#' @importFrom digest digest
print.trellis <- function(x, ...) {
  print_raster(x)
}

#' Print ggplot2 plot to servr
#'
#' @param x ggplot object
#' @param \ldots  additional parameters
#' @export
print.ggplot <- function(x, ...) {
  print_raster(x)
}

print_raster <- function(x) {
  raster_opt <- getOption("rmote_raster")
  if(is.null(raster_opt) || !is.logical(raster_opt))
    raster_opt <- FALSE

  if(raster_opt) {
    output_dir <- file.path(get_server_dir(), "plots")
    plot_digest <- digest(x)
    file <- paste0(plot_digest, ".png")
    if(!file.exists(output_dir))
      dir.create(output_dir, recursive = TRUE)
    output <- file.path(output_dir, file)
    png(filename = output)
    if(inherits(x, "trellis"))
      lattice:::print.trellis(x)
    if(inherits(x, "ggplot"))
      ggplot2:::print.ggplot(x)
    dev.off()

    html <- tags$html(
      tags$head(tags$title(paste("raster plot:", plot_digest))),
      tags$body(img(src = file.path("plots", file))))
    if(getOption("rmote_use_live", default = FALSE))
      html <- attachDependencies(html, htmltools::htmlDependency(name = "live", src = file.path(system.file(package = "rmote"), "live"), version = "4", script = "live.js"))

    htmltools::save_html(html, file = file.path(get_server_dir(), "index.html"))
    # need to make another change for some reason for live.js to always update
    random_pad()

    return()
  }

  if(inherits(x, "trellis"))
    lattice:::print.trellis(x)
  if(inherits(x, "ggplot"))
    ggplot2:::print.ggplot(x)
}





