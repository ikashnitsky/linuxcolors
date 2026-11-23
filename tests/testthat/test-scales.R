library(ggplot2)

test_that("qualitative palettes give discrete scales", {
  s <- scale_colour_linux()
  expect_s3_class(s, "ScaleDiscrete")
  expect_equal(s$aesthetics, "colour")
  expect_equal(s$palette(3), linux_colors("main", 3))
  expect_s3_class(scale_fill_linux("neon"), "ScaleDiscrete")
  expect_identical(scale_color_linux, scale_colour_linux)
})

test_that("sequential and diverging palettes give continuous scales", {
  expect_s3_class(scale_colour_linux("arch"), "ScaleContinuous")
  expect_s3_class(scale_fill_linux("pop"), "ScaleContinuous")
  expect_s3_class(scale_fill_linux("mint", discrete = TRUE), "ScaleDiscrete")
})

test_that("qualitative palettes refuse continuous data", {
  expect_error(scale_colour_linux("main", discrete = FALSE), "qualitative")
})

test_that("colours are mapped by position, not by distro name", {
  df <- data.frame(x = 1:3, y = 1:3, g = c("a", "b", "c"))
  p <- ggplot(df, aes(x, y, colour = g)) + geom_point() + scale_colour_linux()
  expect_equal(layer_data(p)$colour, linux_colors("main", 3))
})

test_that("too many categories give an informative error", {
  df <- data.frame(x = 1:9, y = 1:9, g = letters[1:9])
  p <- ggplot(df, aes(x, y, colour = g)) + geom_point() + scale_colour_linux()
  expect_error(ggplot_build(p), "has 8 colours")
})

test_that("midpoint centres diverging palettes", {
  df <- data.frame(x = 1:3, y = 1:3, v = c(-1, 0, 4))
  p <- ggplot(df, aes(x, y, colour = v)) + geom_point() +
    scale_colour_linux("fedora_redhat", midpoint = 0)
  centre <- linux_colors("fedora_redhat", 3)[2]
  d <- farver::compare_colour(
    farver::decode_colour(layer_data(p)$colour[2]), farver::decode_colour(centre),
    "rgb", method = "cie2000"
  )
  expect_lt(d[1, 1], 1)
  expect_warning(scale_colour_linux("main", midpoint = 0), "ignored")
})

test_that("reverse flips continuous scales", {
  df <- data.frame(x = 1:2, y = 1:2, v = c(0, 1))
  p <- ggplot(df, aes(x, y, colour = v)) + geom_point() +
    scale_colour_linux("arch", reverse = TRUE)
  expect_equal(layer_data(p)$colour[1], linux_colors("arch", 2)[2])
})
