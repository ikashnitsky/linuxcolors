test_that("every palette is valid and documented", {
  info <- linux_palettes_info()
  expect_setequal(info$palette, names(linuxcolors_palettes))
  expect_true(all(info$type %in% c("qualitative", "sequential", "diverging")))
  expect_false(anyNA(info$description))
  for (p in names(linuxcolors_palettes)) {
    expect_match(linuxcolors_palettes[[p]], "^#[0-9A-F]{6}$")
  }
  expect_match(linux_distro_colors, "^#[0-9A-F]{6}$")
  expect_false(anyDuplicated(names(linux_distro_colors)) > 0)
})

test_that("qualitative palettes stay distinct under colour-vision deficiency", {
  skip_if_not_installed("colorspace")
  # Every prefix must be distinct, since scales use the first k colours
  for (p in c("main", "neon")) {
    cols <- unname(linuxcolors_palettes[[p]])
    for (k in 2:length(cols)) {
      expect_gt(worst_case_de(cols[seq_len(k)]), 11)
    }
  }
  expect_gt(worst_case_de(unname(linuxcolors_palettes$main)), 13)
})

test_that("neon colours are light enough for dark backgrounds", {
  expect_true(all(lstar(linuxcolors_palettes$neon) >= 50))
})

test_that("sequential palettes have linear, strictly increasing lightness", {
  for (p in c("ubuntu", "arch", "mint", "distrohop")) {
    l <- lstar(linux_colors(p, 101))
    expect_true(all(diff(l) > 0), label = p)
    expect_gt(summary(stats::lm(l ~ seq_along(l)))$r.squared, 0.995)
    expect_gt(diff(range(l)), 80)
  }
})

test_that("diverging palettes have mirrored lightness and a light centre", {
  for (p in c("fedora_redhat", "pop", "ubuntu_mint")) {
    l <- lstar(linux_colors(p, 101))
    expect_true(all(diff(l[1:51]) > 0), label = p)
    expect_true(all(diff(l[51:101]) < 0), label = p)
    expect_lt(max(abs(l - rev(l))), 1)
    expect_equal(which.max(l), 51)
  }
})

test_that("the two arms of diverging palettes stay distinct under CVD", {
  skip_if_not_installed("colorspace")
  sims <- list(colorspace::deutan, colorspace::protan, colorspace::tritan)
  for (p in c("fedora_redhat", "pop", "ubuntu_mint")) {
    cols <- linuxcolors_palettes[[p]]
    low <- cols[1:5]
    high <- rev(cols[7:11])
    for (f in sims) {
      d <- farver::compare_colour(
        farver::decode_colour(f(low)), farver::decode_colour(f(high)),
        "rgb", method = "cie2000"
      )
      expect_gt(min(diag(d)), 20)
    }
  }
})
