
get_hostname <- function() {
  hn <- try(system("hostname", intern = TRUE, ignore.stderr = TRUE), silent = TRUE)
  if(inherits(hn, "try-error"))
    hn <- ""
  hn
}

get_output_index <- function() {
  server_dir <- get_server_dir()
  idx_path <- file.path(get_server_dir(), ".idx")
  if(!file.exists(idx_path))
    return(1)
  as.integer(readLines(idx_path, warn = FALSE)[1]) + 1
}

get_output_file <- function(ii) {
  sprintf("output%04d.html", ii)
}

set_index_template <- function() {
  a <- readLines(system.file("index.html", package = "rmote"), warn = FALSE)
  if(getOption("rmote_hostname")) {
    idx <- grepl("rmote viewer", a[1:10])
    hn <- get_hostname()
    if(length(idx) > 0 && hn != "")
      a[idx] <- gsub("rmote viewer", paste("rmote:", hn), a[idx])
  }
  options(rmote_index = paste(c(a, ""), collapse = "\n"))
}

write_html <- function(html) {
  ii <- get_output_index()
  fp <- file.path(get_server_dir(), get_output_file(ii))
  htmltools::save_html(
    tagList(HTML("<!-- DISABLE-SERVR-WEBSOCKET -->"), html),
    file = fp)
  write_index(ii)
  fp
}

write_index <- function(ii) {
  if(is.null(getOption("rmote_index")))
    set_index_template()
  res <- gsub("___max_page___", ii, getOption("rmote_index"))
  res <- gsub("___history___", ifelse(is_history_on(), "true", "false"), res)
  # write out file index
  cat(ii, file = file.path(get_server_dir(), ".idx"))
  cat(res, file = file.path(get_server_dir(), "index.html"))
}

is_rmote_on <- function() {
  getOption("rmote_on", FALSE) || length(servr::daemon_list()) > 0
}

is_history_on <- function() {
  getOption("rmote_history", TRUE)
}

no_other_devices <- function() {
  res <- length(dev.list()) == 0
  if(!res) {
    message("- not sending to rmote because another graphics device has been opened...")
    message("- sending to the open graphics device instead...")
    message("- to send to rmote, close all active graphics devices using graphics.off()")
  }
  res
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

text_plot <- function(text) {
  xyplot(NA ~ NA, xlab = "", ylab = "",
    scales = list(draw = FALSE),
    panel = function(x, y, ...)
    panel.text(0.5, 0.5, text, cex = 2.5))
}

#' @importFrom png readPNG
#' @importFrom graphics rasterImage
make_thumb <- function(in_file, out_file, width, height) {
  fbase <- dirname(out_file)
  if(!dir.exists(fbase))
    dir.create(fbase)

  max_height <- 150
  ratio <- max_height / height
  height <- ratio * height
  width <- ratio * width

  img <- png::readPNG(in_file)
  png(filename = out_file, height = height, width = width)
    par(mar = c(0,0,0,0), xaxs = "i", yaxs = "i", ann = FALSE)
    plot(1:2, type = "n", xaxt = "n", yaxt = "n", xlab = "", ylab = "")
    lim <- par()
    graphics::rasterImage(img, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])
  dev.off()
}
