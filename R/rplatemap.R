#' rplatemap
#'
#' R binding to plate-map javascript library
#'
#' @import htmlwidgets
#'
#' @export
rplatemap <- function(nrow=8, ncol=12, readOnly = FALSE, attributes = NULL,
                      data = NULL, width = NULL, height = NULL, elementId = NULL) {

  if (is.null(attributes)) {
    attributes <- list(
      presets = list(),
      tabs = list(
        list(
          name = "Settings",
          fields = list()
        )
      )
    )
  }

  if (is.null(data)) {
    data <- list()
  }

  # forward options using x
  x = list(
    nrow = nrow,
    ncol = ncol,
    readOnly = readOnly,
    attributes = attributes,
    data = data
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'rplatemap',
    x,
    width = width,
    height = height,
    package = 'rplatemap',
    elementId = elementId
  )
}

#' add_single_field
#'
#' create a single field
#'
#' @export
add_single_field <- function(pm, tab_name, id, name, required = FALSE,
                         type = c("text", "numeric", "boolean", "select", "multiselect"),
                         placeholder = "", options = NULL, units = NULL, defaultUnit = NULL) {

  type <- match.arg(type)
  
  if (!is.character(id) || length(id) != 1 || id == "") {
    stop("id should be exactly one, not empty string.")
  }
  if (!is.character(name) || length(name) != 1 || name == "") {
    stop("name should be exactly one, not empty string.")
  }
  if (!is.character(placeholder) || length(placeholder) != 1) {
    stop("placeholder should be exactly one string.")
  }
  if (!is.null(options) && !is.list(options)) {
    options <- lapply(options, function(x) {
      list(id = as.character(x), name = as.character(x))
    })
  }
  if (!is.null(units)) {
    if (!is.character(units)) {
      stop("units should be a character vector")
    }
    if (!is.null(defaultUnit)) {
      if (!is.character(defaultUnit) || length(defaultUnit) != 1) {
        stop("defaultUnit should be exactly one string")
      }
      if (!(defaultUnit %in% units)) {
        stop("defaultUnit should be contained in units")
      }
    }
  }

  field <- list(
    required = required,
    id = id,
    name = name,
    type = type
  )
  if (!is.null(placeholder)) {
    field$placeholder <- placeholder
  }
  if (type %in% c("select", "multiselect")) {
    field$options <- options
  }
  if (!is.null(units)) {
    field$units <- units
    if (!is.null(defaultUnit)) {
      field$defaultUnit <- defaultUnit
    }
  }
  
  i <- which(vapply(pm$x$attributes$tabs, function(tab) tab$name == tab_name, TRUE))
  if (length(i) != 1L) {
    stop(paste("Invalid tab_name:", tab_name))
  }

  pm$x$attributes$tabs[[i]]$fields <- c(pm$x$attributes$tabs[[i]]$fields, list(field))
  pm
}


#' Shiny bindings for rplatemap
#'
#' Output and render functions for using rplatemap within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rplatemap
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rplatemap-shiny
#'
#' @export
rplatemapOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rplatemap', width, height, package = 'rplatemap')
}

#' @rdname rplatemap-rshiny
#' @export
renderRplatemap <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rplatemapOutput, env, quoted = TRUE)
}
