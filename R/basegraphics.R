
#' Let rmote know that a base R plot is complete and ready to serve
#' @export
plot_done <- function() {
  make_base_plot()
  invisible(NULL)
}

make_base_plot <- function() {
  rmb <- getOption("rmote_baseplot")
  if(!is.null(rmb)) {
    dev.off()
    res <- write_html(rmb$html)
    options(rmote_baseplot = NULL)
    make_raster_thumb(res, rmb$cur_type, rmb$opts, rmb$ofile)
  }
}

set_base_plot_hook <- function() {
  options(prev_plot_hook = getHook("before.plot.new"))
  setHook("before.plot.new", function() {
    # if a device was opened up automatically, turn it off
    # (automatic devices don't have a path)
    fp <- attr(.Device, "filepath")
    if(is.null(fp) || fp == "Rplots.pdf")
      dev.off()

    # in case previous plot has never finished
    getFromNamespace("make_base_plot", "rmote")()

    # this will call png or pdf with appropriate options
    dummy <- structure(list(Sys.time()), class = "base_graphics")
    getFromNamespace("print_graphics", "rmote")(dummy)
  }, "replace")
}

unset_base_plot_hook <- function() {
  setHook("before.plot.new", getOption("pre_plot_hook"), "replace")
}

