lstar <- function(cols) farver::decode_colour(cols, to = "lab")[, "l"]

# Worst-case CIEDE2000 distance between any two colours, over normal vision
# and full-severity deutan, protan and tritan simulations
worst_case_de <- function(cols) {
  views <- list(
    identity, colorspace::deutan, colorspace::protan, colorspace::tritan
  )
  d <- Reduce(pmin, lapply(views, function(f) {
    x <- farver::decode_colour(f(cols))
    farver::compare_colour(x, x, "rgb", method = "cie2000")
  }))
  min(d[upper.tri(d)])
}
