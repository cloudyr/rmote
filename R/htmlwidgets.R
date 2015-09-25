
#' Print an htmlwidget to servr
#'
#' @param x htmlwidget object
#' @param \ldots  additional parameters
#' @export
print.htmlwidget <- function(x, ...) {

  widget_opt <- getOption("rmote_htmlwidgets")
  if(is.null(widget_opt) || !is.logical(widget_opt))
    widget_opt <- FALSE

  if(widget_opt) {
    res <- try({
      if(getOption("rmote_use_live", default = FALSE))
        x$dependencies <- c(x$dependencies, list(htmltools::htmlDependency(name = "live", src = file.path(system.file(package = "rmote"), "live"), version = "4", script = "live.js")))
      html <- htmltools::as.tags(x, standalone = TRUE)
      htmltools::save_html(html, file = file.path(get_server_dir(), "index.html"))
      # need to make another change for some reason for live.js to always update
      random_pad()
    })

    if(!inherits(res, "try-error"))
      return()
  }

  htmlwidgets:::print.htmlwidget(x)
}
