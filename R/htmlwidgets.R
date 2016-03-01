
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
      ii <- get_output_index()
      htmltools::save_html(html, file = file.path(get_server_dir(), get_output_file(ii)))
      write_index(ii)
    })

    if(!inherits(res, "try-error"))
      return()
  } else {
    getFromNamespace("print.htmlwidget", "htmlwidgets")(x)
  }
}
