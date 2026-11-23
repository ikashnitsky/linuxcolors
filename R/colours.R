#' Extract colours from a linuxcolors palette
#'
#' `linux_colors()` returns `n` colours from a palette. How the colours are
#' picked depends on the palette type (see [linux_palettes_info()]):
#'
#' * **qualitative** palettes return their first `n` colours. They are never
#'   interpolated, because blends of categorical colours are neither distinct
#'   nor ordered. Asking for more colours than the palette has is an error:
#'   beyond ~8 categories colour alone cannot keep groups apart, so consider
#'   faceting, direct labelling, or lumping rare categories.
#' * **sequential** and **diverging** palettes are sampled evenly along the
#'   palette, interpolating in the perceptually uniform OKLab colour space.
#'
#' `linux_palette()` returns the corresponding palette *function*, which takes
#' `n` and returns `n` colours (the form expected by e.g.
#' [ggplot2::discrete_scale()]).
#'
#' @param palette Name of a palette in [linuxcolors_palettes].
#' @param n Number of colours. `NULL` (default) returns the palette's stored
#'   colours (all colours for qualitative palettes, the 11 nodes for
#'   sequential and diverging palettes).
#' @param reverse If `TRUE`, reverse the order of the colours.
#'
#' @return `linux_colors()`: a character vector of hex colours.
#'   `linux_palette()`: a function of `n`.
#' @seealso [show_linux_palettes()], [scale_colour_linux()]
#' @examples
#' linux_colors("main", 3)
#' linux_colors("ubuntu", 5)
#' linux_colors("fedora_redhat", 7, reverse = TRUE)
#'
#' pal <- linux_palette("arch")
#' pal(4)
#' @export
linux_colors <- function(palette = "main", n = NULL, reverse = FALSE) {
  palette <- check_palette(palette)
  cols <- unname(linuxcolors_palettes[[palette]])
  type <- palette_types[[palette]]

  if (!is.null(n)) {
    if (!is.numeric(n) || length(n) != 1 || is.na(n) || n < 0 || n %% 1 != 0) {
      stop("`n` must be a single non-negative whole number.", call. = FALSE)
    }
    if (type == "qualitative") {
      if (n > length(cols)) {
        stop(
          sprintf(
            "Palette \"%s\" has %d colours, but %d are needed.\n",
            palette, length(cols), n
          ),
          "Qualitative palettes are not interpolated: with that many ",
          "categories colour alone cannot keep them apart.\n",
          "Consider fewer groups, faceting, or direct labels.",
          call. = FALSE
        )
      }
      cols <- cols[seq_len(n)]
    } else {
      cols <- interpolate_oklab(cols, n)
    }
  }

  if (isTRUE(reverse)) rev(cols) else cols
}

#' @rdname linux_colors
#' @export
linux_colours <- linux_colors

#' @rdname linux_colors
#' @export
linux_palette <- function(palette = "main", reverse = FALSE) {
  palette <- check_palette(palette)
  force(reverse)
  function(n) linux_colors(palette, n, reverse = reverse)
}

#' Overview of the linuxcolors palettes
#'
#' @return A data frame with one row per palette and the columns `palette`,
#'   `type` (`"qualitative"`, `"sequential"` or `"diverging"`), `n` (number of
#'   stored colours; the maximum for qualitative palettes) and `description`.
#' @examples
#' linux_palettes_info()
#' @export
linux_palettes_info <- function() {
  nms <- names(linuxcolors_palettes)
  data.frame(
    palette = nms,
    type = unname(palette_types[nms]),
    n = unname(lengths(linuxcolors_palettes)),
    description = unname(palette_descriptions[nms]),
    stringsAsFactors = FALSE
  )
}

#' Preview linuxcolors palettes
#'
#' Draws every palette (or a selection) as a row of colour swatches using base
#' graphics.
#'
#' @param palettes Character vector of palette names. Defaults to all
#'   palettes, or all palettes of the given `type`.
#' @param type Optional palette type(s) to show: `"qualitative"`,
#'   `"sequential"` and/or `"diverging"`.
#' @param n Number of colours for sequential and diverging palettes. `NULL`
#'   (default) draws a smooth ramp; qualitative palettes always show all
#'   their colours.
#' @return The names of the palettes shown, invisibly.
#' @examples
#' show_linux_palettes()
#' show_linux_palettes(type = "sequential", n = 7)
#' @export
show_linux_palettes <- function(palettes = NULL, type = NULL, n = NULL) {
  if (is.null(palettes)) {
    palettes <- names(linuxcolors_palettes)
    if (!is.null(type)) {
      type <- match.arg(type, c("qualitative", "sequential", "diverging"),
                        several.ok = TRUE)
      palettes <- palettes[palette_types[palettes] %in% type]
    }
  }
  palettes <- vapply(palettes, check_palette, character(1), USE.NAMES = FALSE)

  old <- graphics::par(mar = c(0.5, 9, 0.5, 0.5))
  on.exit(graphics::par(old))
  k <- length(palettes)
  graphics::plot.new()
  graphics::plot.window(xlim = c(0, 1), ylim = c(k, 0) + c(0.1, -0.1))
  for (i in seq_len(k)) {
    p <- palettes[[i]]
    cols <- if (palette_types[[p]] == "qualitative") {
      linux_colors(p)
    } else {
      linux_colors(p, if (is.null(n)) 256 else n)
    }
    m <- length(cols)
    x <- seq(0, 1, length.out = m + 1)
    gap <- if (m > 40) 0 else 0.004
    graphics::rect(x[-(m + 1)] + gap, i - 0.9, x[-1] - gap, i - 0.1,
                   col = cols, border = NA)
    graphics::mtext(p, side = 2, at = i - 0.5, las = 1, line = 0.5,
                    cex = 0.9)
  }
  invisible(palettes)
}

# Helpers --------------------------------------------------------------------

check_palette <- function(palette) {
  if (!is.character(palette) || length(palette) != 1 || is.na(palette)) {
    stop("`palette` must be a single palette name.", call. = FALSE)
  }
  if (palette %in% names(legacy_palettes)) {
    new <- legacy_palettes[[palette]]
    warning(
      sprintf(
        "Palette \"%s\" was removed in linuxcolors 0.1.0; using \"%s\" instead.",
        palette, new
      ),
      call. = FALSE
    )
    palette <- new
  }
  if (!palette %in% names(linuxcolors_palettes)) {
    stop(
      sprintf("Unknown palette \"%s\". Choose one of: ", palette),
      paste(names(linuxcolors_palettes), collapse = ", "), ".",
      call. = FALSE
    )
  }
  palette
}

# Evenly sample `n` colours along the piecewise-linear path through `cols`
# in OKLab space
interpolate_oklab <- function(cols, n) {
  if (n == 0) return(character())
  if (n == 1) return(interpolate_oklab(cols, 3)[2])
  lab <- farver::decode_colour(cols, to = "oklab")
  at <- seq(0, 1, length.out = nrow(lab))
  x <- seq(0, 1, length.out = n)
  out <- vapply(
    seq_len(3), function(j) stats::approx(at, lab[, j], xout = x)$y,
    numeric(n)
  )
  farver::encode_colour(matrix(out, ncol = 3), from = "oklab")
}
