# Generator for the continuous palettes in R/palettes.R
#
# Design rules, following Crameri, Shephard & Heron (2020) "The misuse of
# colour in science communication", Nature Communications 11:5444, and the
# Scientific colour maps (https://www.fabiocrameri.ch/colourmaps):
#
#   * Perceptually ordered: CIE L* (the value a greyscale print keeps) is
#     linear and strictly monotonic (sequential), or linear and exactly
#     mirrored around a light centre (diverging).
#   * Perceptually uniform: hue and chroma vary smoothly (natural splines in
#     OKLab), so the maps have no kinks that read as artificial boundaries;
#     sequential nodes are then spaced at equal perceptual (OKLab) distance.
#   * CVD friendly: anchors are chosen so that the maps stay ordered and the
#     two arms of diverging maps stay distinct under deutan/protan/tritan
#     simulation (checked in tests/testthat/test-palettes.R).
#
# Brand colours of Linux distributions are used as *anchors*: they fix the
# hue/chroma path, but their lightness is overridden, so the generated nodes
# are tints and shades of the brand colours rather than the colours verbatim.
#
# Run from the package root and paste the printed vectors into R/palettes.R:
#   Rscript data-raw/palettes.R

library(farver)

oklab <- function(hex) convert_colour(decode_colour(hex), "rgb", "oklab")
lstar_of <- function(lab) convert_colour(matrix(lab, nrow = 1), "oklab", "lab")[1]

# farver clamps RGB output to [0, 255], so test gamut membership by round trip
in_gamut <- function(lab) {
  lab <- matrix(lab, nrow = 1)
  back <- convert_colour(convert_colour(lab, "oklab", "rgb"), "rgb", "oklab")
  max(abs(back - lab)) < 1e-3
}

# OKLab colour with chroma direction (a, b) and the given CIE L*
solve_l <- function(target, a, b) {
  stats::uniroot(
    function(L) lstar_of(c(L, a, b)) - target, c(0, 1.2), tol = 1e-7
  )$root
}

# Colour with the given L* and OKLab (a, b); chroma is reduced (keeping hue
# and L*) until the colour fits in sRGB
place <- function(target, a, b) {
  fits <- function(k) in_gamut(c(solve_l(target, k * a, k * b), k * a, k * b))
  k <- 1
  if (!fits(1)) {
    lo <- 0; hi <- 1
    for (i in 1:25) { mid <- (lo + hi) / 2; if (fits(mid)) lo <- mid else hi <- mid }
    k <- lo
  }
  c(solve_l(target, k * a, k * b), k * a, k * b)
}

# Dense path along one arm. `anchors` are placed at CIE L* values `l_at`;
# their OKLab (a, b) are interpolated as smooth functions of L*.
make_arm <- function(anchors, l_at, l_from, l_to, n = 201) {
  A <- oklab(anchors)
  Ls <- seq(l_from, l_to, length.out = n)
  a <- stats::spline(l_at, A[, 2], xout = Ls, method = "natural")$y
  b <- stats::spline(l_at, A[, 3], xout = Ls, method = "natural")$y
  list(lstar = Ls, lab = t(mapply(place, Ls, a, b)))
}

to_hex <- function(lab) encode_colour(convert_colour(lab, "oklab", "rgb"))

# Resample to k nodes equally spaced in (L*-weighted) OKLab arc length.
# Lightness is weighted x2 so it stays near-linear while chroma/hue changes
# are spread evenly.
resample_arc <- function(arm, k, wL = 2) {
  lab <- arm$lab
  d <- sqrt((wL * diff(lab[, 1]))^2 + diff(lab[, 2])^2 + diff(lab[, 3])^2)
  s <- c(0, cumsum(d)) / sum(d)
  to_hex(sapply(1:3, function(j) stats::approx(s, lab[, j], seq(0, 1, length.out = k))$y))
}

# Resample at exactly equal L* steps (used for diverging arms: symmetry first)
resample_l <- function(arm, k) {
  x <- seq(arm$lstar[1], arm$lstar[length(arm$lstar)], length.out = k)
  to_hex(sapply(1:3, function(j) stats::approx(arm$lstar, arm$lab[, j], x)$y))
}

sequential <- function(anchors, l_at, l_from, l_to, k = 11) {
  resample_arc(make_arm(anchors, l_at, l_from, l_to), k)
}

# Two arms with identical L* profiles meeting at a light neutral centre.
# `low`/`high` anchors are ordered centre -> end, placed at `l_low`/`l_high`.
diverging <- function(low, high, l_low, l_high, l_centre = 96, l_end = 25, k = 11) {
  stopifnot(k %% 2 == 1)
  centre <- "#F4F4F4"
  h <- (k + 1) / 2
  lo <- resample_l(make_arm(c(centre, low), c(l_centre, l_low), l_centre, l_end), h)
  hi <- resample_l(make_arm(c(centre, high), c(l_centre, l_high), l_centre, l_end), h)
  c(rev(lo), hi[-1])
}

continuous <- list(
  # Ubuntu: dark aubergine -> aubergine -> Ubuntu orange -> Pop!_OS amber -> cream
  ubuntu = sequential(
    c("#2C001E", "#77216F", "#E95420", "#FAA41A", "#FFF4D6"),
    c(8, 30, 58, 76, 96), 10, 95
  ),
  # Arch: MX Linux navy -> AlmaLinux cobalt -> Arch blue -> elementary sky -> ice
  arch = sequential(
    c("#243365", "#1158AE", "#1793D1", "#64BAFF", "#EAF5FF"),
    c(12, 37, 58, 73, 96), 10, 95
  ),
  # Mint: openSUSE pine -> Void green -> Manjaro -> Linux Mint -> pale lime
  mint = sequential(
    c("#173F4F", "#478061", "#34BE5B", "#87CF3E", "#F1FAD9"),
    c(12, 40, 60, 77, 96), 10, 95
  ),
  # Distrohop: multi-hue walk (in the spirit of batlow/viridis) across distros:
  # MX navy -> NixOS blue -> openSUSE jungle -> Linux Mint -> Pop!_OS amber -> light
  distrohop = sequential(
    c("#243365", "#5277C3", "#35B9AB", "#87CF3E", "#FAD25A", "#FFF6C9"),
    c(12, 35, 55, 70, 84, 96), 10, 95
  ),
  # Fedora blue (low) <-> Red Hat red (high)
  fedora_redhat = diverging(
    low  = c("#51A2DA", "#294172"), high = c("#EE0000", "#7A0000"),
    l_low = c(63, 25), l_high = c(50, 20)
  ),
  # Pop!_OS teal (low) <-> Pop!_OS amber (high)
  pop = diverging(
    low  = c("#48B9C7", "#0E5A63"), high = c("#FAA41A", "#7A4300"),
    l_low = c(68, 30), l_high = c(74, 30)
  ),
  # Ubuntu aubergine (low) <-> Linux Mint green (high). The green arm is kept
  # yellow-green (not teal) so its dark end stays distinct from the aubergine
  # end for deuteranopes.
  ubuntu_mint = diverging(
    low  = c("#77216F", "#2C001E"), high = c("#87CF3E", "#2B5413"),
    l_low = c(30, 10), l_high = c(76, 30)
  )
)

for (nm in names(continuous)) {
  cat(sprintf("  %s = c(\n    %s\n  ),\n", nm,
              paste(strwrap(paste0('"', continuous[[nm]], '"', collapse = ", "), 72),
                    collapse = "\n    ")))
}

if (nzchar(Sys.getenv("LC_SAVE"))) saveRDS(continuous, Sys.getenv("LC_SAVE"))
