#' Print trellis plot to servr
#'
#' @param x trellis object
#' @param \ldots  additional parameters
#' @S3method print trellis
#' @import htmltools
#' @importFrom digest digest
print.trellis <- function(x, ...) {
  print_graphics(x)
}

#' Print ggplot2 plot to servr
#'
#' @param x ggplot object
#' @param \ldots  additional parameters
#' @S3method print ggplot
print.ggplot <- function(x, ...) {
  print_graphics(x)
}

print_graphics <- function(x) {

  graphics_opt <- getOption("rmote_graphics", FALSE)

  if(is_rmote_on() && graphics_opt) {
    message("serving graphics through rmote")

    output_dir <- file.path(get_server_dir(), "plots")
    if(!file.exists(output_dir))
      dir.create(output_dir, recursive = TRUE)

    opts <- getOption("rmote_device")
    if(is.null(opts)) {
      rmote_device()
      opts <- getOption("rmote_device")
    }

    if(is.null(opts$filename)) {
      plot_base <- digest::digest(x)
    } else {
      plot_base <- opts$filename
    }
    file <- file.path("plots", paste0(plot_base, ".", opts$type))
    ofile <- file.path(output_dir, paste0(plot_base, ".", opts$type))

    if(opts$type == "png") {
      ww <- opts$width
      hh <- opts$height
      if(opts$retina) {
        opts$width <- opts$width * 2
        opts$height <- opts$height * 2
        opts$res <- 150
      }
      html <- tags$html(
        tags$head(tags$title(paste("raster plot:", plot_base))),
        tags$body(tags$img(src = file,
          width = paste0(ww, "'x"), height = paste0(hh, "'x"))))
      opts$type <- NULL
      opts$retina <- NULL
      opts$filename <- ofile
      if(capabilities("cairo"))
        opts$type <- "cairo-png"
      do.call(png, opts)
    } else if(opts$type == "pdf") {
      html <- tags$html(
        tags$head(tags$title(paste("raster plot:", plot_base))),
        tags$body(tags$a(href = file, "pdf", target = "_blank")))
      opts$type <- NULL
      opts$file <- ofile
      do.call(pdf, opts)
    }
    if(inherits(x, "trellis"))
      getFromNamespace("print.trellis", "lattice")(x)
    if(inherits(x, "ggplot"))
      getFromNamespace("print.ggplot", "ggplot2")(x)
    dev.off()

    ii <- get_output_index()
    htmltools::save_html(html, file = file.path(get_server_dir(), get_output_file(ii)))
    write_index(ii)

    return()
  } else {
    if(inherits(x, "trellis"))
      getFromNamespace("print.trellis", "lattice")(x)
    if(inherits(x, "ggplot"))
      getFromNamespace("print.ggplot", "ggplot2")(x)
  }
}

#' Set device parameters for traditional grahpics plot output
#'
#' @param type either "png" or "pdf"
#' @param filename optional name for file (should have no extension and no directories)
#' @param retina if TRUE and type is "png", the png file will be plotted at twice its size and shown at the original size, to look better on high resolution displays
#' @param \ldots parameters passed on to either \code{\link[grDevices]{png}} or \code{\link[grDevices]{pdf}} (such as width, height, etc.)
#' @export
rmote_device <- function(type = c("png", "pdf"), filename = NULL, retina = TRUE, ...) {

  type <- match.arg(type)
  opts <- list(...)
  opts$type <- type
  opts$filename <- filename
  if(type == "png") {
    opts$retina <- retina
    if(is.null(opts$width))
      opts$width <- 480
    if(is.null(opts$height))
      opts$height <- 480
  }

  options(rmote_device = opts)
}





