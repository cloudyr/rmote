
#' Print an htmlwidget to servr
#'
#' @param x htmlwidget object
#' @param \ldots  additional parameters
#' @S3method print htmlwidget
print.htmlwidget <- function(x, ...) {

  widget_opt <- getOption("rmote_htmlwidgets", FALSE)

  if(is_rmote_on() && widget_opt) {
    message("serving htmlwidgets through rmote")

    res <- try({
      html <- htmltools::as.tags(x, standalone = TRUE)
      write_html(html)
    })

    if(!inherits(res, "try-error"))
      return()
  } else {
    getFromNamespace("print.htmlwidget", "htmlwidgets")(x)
  }
}

