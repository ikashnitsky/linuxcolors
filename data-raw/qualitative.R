# Selection and ordering of the qualitative palettes in R/palettes.R
#
# Criterion: the worst-case CIEDE2000 distance between any two colours, where
# "worst case" is taken over normal vision and full-severity deuteranopia,
# protanopia and tritanopia (simulated with colorspace). Colours are then
# ordered so that every prefix (the first k colours, as used by a discrete
# scale with k levels) is as distinct as possible.
#
# Run from the package root:  Rscript data-raw/qualitative.R

library(farver)
library(colorspace)
devtools::load_all(quiet = TRUE)

pool <- linux_distro_colors[!names(linux_distro_colors) %in%
  c("Ubuntu dark aubergine", "Ubuntu warm grey")]  # near-black and neutral

views <- list(identity, deutan, protan, tritan)
D <- Reduce(pmin, lapply(views, function(f) {
  x <- decode_colour(f(unname(pool)))
  compare_colour(x, x, "rgb", method = "cie2000")
}))
dimnames(D) <- list(names(pool), names(pool))
worst <- function(s) min(D[s, s][upper.tri(D[s, s])])

# Exhaustive search over subsets of `cand` of size n that contain `must`
best_subset <- function(n, cand, must = character()) {
  free <- setdiff(cand, must)
  cb <- utils::combn(free, n - length(must))
  v <- apply(cb, 2, function(cc) worst(c(must, cc)))
  list(colours = c(must, cb[, which.max(v)]), worst = max(v))
}

# Order maximising the sum of prefix worst-case distances (greedy from every
# starting colour). The first two colours form a symmetric pair, so their
# order is a free choice.
best_order <- function(s) {
  score <- function(o) sum(sapply(2:length(o), function(k) worst(o[1:k])))
  starts <- lapply(s, function(a) {
    o <- a
    while (length(o) < length(s)) {
      r <- setdiff(s, o)
      o <- c(o, r[which.max(sapply(r, function(z) min(D[z, o])))])
    }
    o
  })
  starts[[which.max(sapply(starts, score))]]
}

# main: 8 colours, must include the two most iconic distro colours
main <- best_subset(8, names(pool), must = c("Ubuntu", "Arch Linux"))
main_order <- best_order(main$colours)
cat("main:", paste(main_order, collapse = ", "), "\n")
cat("  prefix worst-case dE:",
    round(sapply(2:8, function(k) worst(main_order[1:k])), 1), "\n")

# neon: 5 bright colours (CIE L* >= 50) for dark backgrounds. Several sets tie
# at the optimum; the one with the widest hue range was preferred.
lstar <- decode_colour(pool, to = "lab")[, "l"]
bright <- names(pool)[lstar >= 50]
neon <- c("Ubuntu", "NixOS", "CachyOS", "Linux Mint", "Fedora blue")
cat("neon optimum:", round(best_subset(5, bright)$worst, 1),
    "| chosen set:", round(worst(neon), 1), "\n")
cat("neon:", paste(best_order(neon), collapse = ", "), "\n")

# Reference: Okabe-Ito without black
oi <- unname(grDevices::palette.colors(9, "Okabe-Ito")[-1])
x <- Reduce(pmin, lapply(views, function(f) {
  y <- decode_colour(f(oi)); compare_colour(y, y, "rgb", method = "cie2000")
}))
cat("Okabe-Ito (8, no black) worst-case dE:", round(min(x[upper.tri(x)]), 1), "\n")
