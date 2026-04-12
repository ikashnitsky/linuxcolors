#' Linux Distribution Color Palettes Interpolation
#'
#' Interpolate colors from the linuxcolors palettes for continuous or discrete mappings.
#'
#' @param palette Character name of palette in linuxcolors_palettes.
#' @param reverse Boolean indicating whether the palette should be reversed. Default is \code{FALSE}.
#' @param ... Additional arguments to pass to \code{\link[grDevices]{colorRampPalette}}.
#'
#' @return A function that takes an integer argument (the required number of colors) and
#' returns a character vector of colors.
#' @export
#'
#' @examples
#' linux_palette("main")(5)
linux_palette <- function(palette = "main", reverse = FALSE, ...) {
  pal <- linuxcolors_palettes[[palette]]
  if (is.null(pal)) {
    stop(
      "Palette not found. Choose from: ",
      paste(names(linuxcolors_palettes), collapse = ", ")
    )
  }
  if (reverse) {
    pal <- rev(pal)
  }
  grDevices::colorRampPalette(pal, ...)
}

#' Color scale constructor for linuxcolors palettes
#'
#' Apply linuxcolors palettes to \code{ggplot2} objects for color aesthetics.
#'
#' @param palette Character name of palette in \code{linuxcolors_palettes}. Default is \code{"main"}.
#' @param discrete Boolean indicating whether color aesthetic is discrete (\code{TRUE}) or continuous (\code{FALSE}).
#' @param reverse Boolean indicating whether the palette should be reversed. Default is \code{FALSE}.
#' @param ... Additional arguments passed to \code{\link[ggplot2]{discrete_scale}} or
#' \code{\link[ggplot2]{scale_color_gradientn}}, depending on the value of \code{discrete}.
#'
#' @return A \code{ScaleContinuous} or \code{ScaleDiscrete} object that can be added to a \code{ggplot}.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(mpg, wt, color = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_color_linux("main")
scale_color_linux <- function(
  palette = "main",
  discrete = TRUE,
  reverse = FALSE,
  ...
) {
  pal <- linux_palette(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(
      "colour",
      paste0("linux_", palette),
      palette = pal,
      ...
    )
  } else {
    ggplot2::scale_color_gradientn(colours = pal(256), ...)
  }
}

#' Fill scale constructor for linuxcolors palettes
#'
#' Apply linuxcolors palettes to \code{ggplot2} objects for fill aesthetics.
#'
#' @param palette Character name of palette in \code{linuxcolors_palettes}. Default is \code{"main"}.
#' @param discrete Boolean indicating whether color aesthetic is discrete (\code{TRUE}) or continuous (\code{FALSE}).
#' @param reverse Boolean indicating whether the palette should be reversed. Default is \code{FALSE}.
#' @param ... Additional arguments passed to \code{\link[ggplot2]{discrete_scale}} or
#' \code{\link[ggplot2]{scale_fill_gradientn}}, depending on the value of \code{discrete}.
#'
#' @return A \code{ScaleContinuous} or \code{ScaleDiscrete} object that can be added to a \code{ggplot}.
#' @export
#'
#' @examples
#' library(ggplot2)
#' ggplot(mtcars, aes(factor(cyl), fill = factor(vs))) +
#'   geom_bar() +
#'   scale_fill_linux("additional")
scale_fill_linux <- function(
  palette = "main",
  discrete = TRUE,
  reverse = FALSE,
  ...
) {
  pal <- linux_palette(palette = palette, reverse = reverse)

  if (discrete) {
    ggplot2::discrete_scale(
      "fill",
      paste0("linux_", palette),
      palette = pal,
      ...
    )
  } else {
    ggplot2::scale_fill_gradientn(colours = pal(256), ...)
  }
}
