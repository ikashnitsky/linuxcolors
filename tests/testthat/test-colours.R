test_that("linux_colors() returns the requested colours", {
  expect_equal(linux_colors("main"), unname(linuxcolors_palettes$main))
  expect_equal(linux_colors("main", 3), unname(linuxcolors_palettes$main[1:3]))
  expect_equal(linux_colors("main", 3, reverse = TRUE),
               rev(unname(linuxcolors_palettes$main[1:3])))
  expect_length(linux_colors("arch", 7), 7)
  expect_length(linux_colors("arch", 0), 0)
  expect_length(linux_colors("arch", 1), 1)
  expect_identical(linux_colours, linux_colors)
})

test_that("interpolation keeps the stored nodes", {
  cols <- linuxcolors_palettes$ubuntu
  expect_equal(linux_colors("ubuntu", length(cols)), cols)
  expect_equal(linux_colors("ubuntu", 21)[c(1, 21)], cols[c(1, 11)])
})

test_that("qualitative palettes are never interpolated", {
  expect_error(linux_colors("main", 9), "has 8 colours")
  expect_error(linux_colors("neon", 6), "has 5 colours")
})

test_that("bad input gives informative errors", {
  expect_error(linux_colors("nope"), "Unknown palette")
  expect_error(linux_colors(c("main", "neon")), "single palette name")
  expect_error(linux_colors("main", 2.5), "whole number")
})

test_that("legacy palette names map to their replacements", {
  expect_warning(cols <- linux_colors("sequential_green"), "using \"mint\"")
  expect_equal(cols, linux_colors("mint"))
})

test_that("linux_palette() returns a palette function", {
  pal <- linux_palette("pop", reverse = TRUE)
  expect_type(pal, "closure")
  expect_equal(pal(5), linux_colors("pop", 5, reverse = TRUE))
})

test_that("show_linux_palettes() draws without error", {
  path <- tempfile(fileext = ".pdf")
  grDevices::pdf(path)
  on.exit({ grDevices::dev.off(); unlink(path) })
  expect_invisible(show_linux_palettes())
  expect_equal(show_linux_palettes(type = "diverging", n = 5),
               c("fedora_redhat", "pop", "ubuntu_mint"))
})
