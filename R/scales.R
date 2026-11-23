#' ggplot2 colour and fill scales from linuxcolors palettes
#'
#' Apply a [linuxcolors_palettes] palette to the `colour` or `fill` aesthetic.
#' The scale type follows the palette type: qualitative palettes give discrete
#' scales; sequential and diverging palettes give continuous scales by default
#' and can also be used for ordered discrete data with `discrete = TRUE`.
#'
#' @param palette Name of a palette in [linuxcolors_palettes]; see
#'   [linux_palettes_info()].
#' @param discrete Use a discrete scale? Defaults to `TRUE` for qualitative
#'   palettes and `FALSE` otherwise. Qualitative palettes cannot be used for
#'   continuous data, because interpolating between categorical colours
#'   produces an unordered, misleading colour map.
#' @param reverse If `TRUE`, reverse the palette.
#' @param midpoint For continuous scales: data value mapped to the centre of
#'   the palette. Set it for diverging palettes so that the light centre marks
#'   a meaningful reference value (e.g. `0`, or a baseline). `NULL` (default)
#'   maps the data range linearly onto the palette. For transformed scales,
#'   give the midpoint on the transformed scale.
#' @param aesthetics The aesthetic(s) the scale applies to.
#' @param ... Further arguments passed to [ggplot2::discrete_scale()] or
#'   [ggplot2::continuous_scale()], e.g. `name`, `limits`, `breaks`, `guide`.
#'
#' @return A ggplot2 scale.
#' @seealso [linux_colors()] to get the colours themselves.
#' @examples
#' library(ggplot2)
#'
#' # Qualitative palette for groups
#' ggplot(mtcars, aes(wt, mpg, colour = factor(cyl))) +
#'   geom_point(size = 3) +
#'   scale_colour_linux()
#'
#' # Sequential palette for a continuous variable
#' ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
#'   geom_raster() +
#'   scale_fill_linux("distrohop")
#'
#' # Diverging palette centred at a meaningful value
#' ggplot(mtcars, aes(wt, mpg, colour = mpg - mean(mpg))) +
#'   geom_point(size = 3) +
#'   scale_colour_linux("fedora_redhat", midpoint = 0)
#'
#' # Sequential palette for an ordered factor
#' ggplot(diamonds, aes(carat, price, colour = cut)) +
#'   geom_point(alpha = 0.5) +
#'   scale_colour_linux("ubuntu", discrete = TRUE)
#' @export
scale_colour_linux <- function(palette = "main", discrete = NULL,
                               reverse = FALSE, midpoint = NULL,
                               aesthetics = "colour", ...) {
  linux_scale(palette, discrete, reverse, midpoint, aesthetics, ...)
}

#' @rdname scale_colour_linux
#' @export
scale_color_linux <- scale_colour_linux

#' @rdname scale_colour_linux
#' @export
scale_fill_linux <- function(palette = "main", discrete = NULL,
                             reverse = FALSE, midpoint = NULL,
                             aesthetics = "fill", ...) {
  linux_scale(palette, discrete, reverse, midpoint, aesthetics, ...)
}

linux_scale <- function(palette, discrete, reverse, midpoint, aesthetics, ...) {
  palette <- check_palette(palette)
  type <- palette_types[[palette]]
  if (is.null(discrete)) discrete <- type == "qualitative"

  if (discrete) {
    if (!is.null(midpoint)) {
      warning("`midpoint` is ignored for discrete scales.", call. = FALSE)
    }
    return(ggplot2::discrete_scale(
      aesthetics,
      palette = linux_palette(palette, reverse = reverse),
      ...
    ))
  }

  if (type == "qualitative") {
    stop(
      sprintf("Palette \"%s\" is qualitative and only works for discrete data.\n", palette),
      "For continuous data use a sequential or diverging palette, e.g. ",
      "\"distrohop\" or \"fedora_redhat\"; see `linux_palettes_info()`.",
      call. = FALSE
    )
  }

  args <- list(
    aesthetics,
    palette = scales::pal_gradient_n(
      linux_colors(palette, 256, reverse = reverse)
    ),
    ...
  )
  if (!is.null(midpoint)) {
    if (!is.numeric(midpoint) || length(midpoint) != 1) {
      stop("`midpoint` must be a single number.", call. = FALSE)
    }
    args$rescaler <- function(x, to = c(0, 1), from = range(x, na.rm = TRUE)) {
      scales::rescale_mid(x, to = to, from = from, mid = midpoint)
    }
  }
  if (is.null(args$guide)) args$guide <- "colourbar"
  do.call(ggplot2::continuous_scale, args)
}
