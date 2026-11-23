

# **linuxcolors: color palettes from the identity colors of the most popular Linux distros** <a href='https://github.com/ikashnitsky/linuxcolors'><img src='inst/logo/logo-linuxcolors-small.png' align="right" width="20%" min-width="200px"/></a>

![](inst/logo/logo-card.png)

`linuxcolors` turns the brand colours of Linux distributions (Ubuntu
orange, Arch blue, Fedora blue, Debian red, Linux Mint green, …) into
palettes for data visualisation. They follow the best practices for
scientific colour use set out by [Crameri, Shephard & Heron
(2020)](https://doi.org/10.1038/s41467-020-19160-7) and the [Scientific
colour maps](https://www.fabiocrameri.ch/colourmaps):

- **Perceptually ordered.** Lightness (CIE L\*) rises linearly and
  monotonically in sequential palettes. In diverging palettes it is
  exactly mirrored around a light centre.
- **Perceptually uniform.** Hue and chroma change smoothly, and equal
  data steps look like equal colour steps. There are no kinks, which
  would read as false boundaries.
- **Colour-vision-deficiency (CVD) friendly.** Qualitative colours stay
  distinct under deuteranopia, protanopia and tritanopia. Continuous
  maps keep their order.
- **Readable in greyscale.** This follows from the linear lightness.
- **No rainbow, no interpolated categories.** Qualitative palettes are
  never blended. Continuous palettes are interpolated in the OKLab
  colour space.

These properties are checked by the package’s test suite.

## Installation

``` r
# install.packages("pak")
pak::pak("ikashnitsky/linuxcolors")
```

## Palettes

``` r
library(linuxcolors)
linux_palettes_info()
```

            palette        type  n
    1          main qualitative  8
    2          neon qualitative  5
    3        ubuntu  sequential 11
    4          arch  sequential 11
    5          mint  sequential 11
    6     distrohop  sequential 11
    7 fedora_redhat   diverging 11
    8           pop   diverging 11
    9   ubuntu_mint   diverging 11
                                                 description
    1 Default; 8 CVD-robust distro colours, best-first order
    2                    Bright colours for dark backgrounds
    3                           Aubergine to orange to cream
    4                               Navy to Arch blue to ice
    5                        Pine to Mint green to pale lime
    6                    Multi-hue: navy, teal, green, amber
    7                            Fedora blue <-> Red Hat red
    8                         Pop!_OS teal <-> Pop!_OS amber
    9                  Ubuntu aubergine <-> Linux Mint green

``` r
show_linux_palettes()
```

![](README_files/figure-commonmark/palettes-1.png)

**Qualitative** (for categories):

- `main` is the default. It has 8 colours (Pop!\_OS, MX Linux, CachyOS,
  Debian, Arch Linux, EndeavourOS, Void Linux, Ubuntu), selected among
  the brand colours in `linux_distro_colors` to maximise the
  *worst-case* CIEDE2000 distance across normal vision and the three
  dichromacies. The minimum ΔE is 13.3; the 8 Okabe–Ito colours (without
  black) reach 6.4. The order is optimised too, so the first *k* colours
  are as distinct as possible for any *k*. Need more than 8 categories?
  Colour alone won’t keep them apart; facet, label directly, or lump
  rare groups.
- `neon` has 5 bright colours (L\* ≥ 50) for dark backgrounds.

**Sequential** (dark → light): `ubuntu` (aubergine → orange → cream),
`arch` (navy → Arch blue → ice), `mint` (pine → Mint green → pale lime),
and the multi-hue `distrohop` (navy → teal → green → amber, in the
spirit of *batlow* and *viridis*).

**Diverging** (light centre): `fedora_redhat` (Fedora blue ↔ Red Hat
red), `pop` (Pop!\_OS teal ↔ amber), and `ubuntu_mint` (Ubuntu aubergine
↔ Linux Mint green).

In the continuous palettes, brand colours are *anchors*: they set the
hue and chroma, and the lightness is recomputed to obey the rules above.
The generating script is [`data-raw/palettes.R`](data-raw/palettes.R).
The raw brand colours are available in `linux_distro_colors`.

### How they look with colour-vision deficiency and in greyscale

``` r
library(colorspace)

sims <- list(
  normal = identity, deuteranopia = deutan, protanopia = protan,
  tritanopia = tritan, greyscale = desaturate
)
pals <- names(linuxcolors_palettes)

op <- par(mfrow = c(1, length(sims)), mar = c(0.5, 0.5, 2, 0.5), oma = c(0, 9, 0, 0))
for (s in names(sims)) {
  plot.new()
  plot.window(c(0, 1), c(length(pals), 0))
  title(s, font.main = 1)
  for (i in seq_along(pals)) {
    cols <- linux_colors(pals[i], if (pals[i] %in% c("main", "neon")) NULL else 64)
    cols <- sims[[s]](cols)
    x <- seq(0, 1, length.out = length(cols) + 1)
    rect(head(x, -1), i - 0.9, x[-1], i - 0.1, col = cols, border = NA)
    if (s == "normal") mtext(pals[i], side = 2, at = i - 0.5, las = 1, line = 0.3, outer = FALSE, xpd = NA)
  }
}
```

![](README_files/figure-commonmark/cvd-1.png)

``` r
par(op)
```

## Usage

`linux_colors()` extracts colours. Qualitative palettes return their
first `n` colours; sequential and diverging palettes are sampled evenly:

``` r
linux_colors("main", 3)
```

    [1] "#FAA41A" "#243365" "#00D2CF"

``` r
linux_colors("ubuntu", 5)
```

    [1] "#37062C" "#7C236E" "#D8464B" "#FE9D22" "#FEF0CD"

`scale_colour_linux()` / `scale_color_linux()` and `scale_fill_linux()`
plug into ggplot2. The scale type follows the palette type: qualitative
palettes give discrete scales, and sequential and diverging palettes
give continuous ones.

``` r
library(ggplot2)
theme_set(theme_minimal(base_size = 13))

# Qualitative: groups
ggplot(penguins, aes(flipper_len, body_mass, colour = species)) +
  geom_point(size = 2, alpha = 0.8, na.rm = TRUE) +
  scale_colour_linux()
```

![](README_files/figure-commonmark/usage-discrete-1.png)

``` r
# Sequential: a continuous quantity
ggplot(faithfuld, aes(waiting, eruptions, fill = density)) +
  geom_raster() +
  scale_fill_linux("distrohop") +
  coord_cartesian(expand = FALSE)
```

![](README_files/figure-commonmark/usage-sequential-1.png)

``` r
# Diverging: deviations from a meaningful reference, centred with `midpoint`
ggplot(swiss, aes(Agriculture, Fertility, colour = Fertility - median(Fertility))) +
  geom_point(size = 3) +
  scale_colour_linux("fedora_redhat", midpoint = 0, name = "Fertility\nvs median") +
  theme(panel.background = element_rect(fill = "grey90", colour = NA))
```

![](README_files/figure-commonmark/usage-diverging-1.png)

``` r
# Sequential palette for an ordered factor
ggplot(diamonds, aes(cut, fill = clarity)) +
  geom_bar(position = "fill") +
  scale_fill_linux("ubuntu", discrete = TRUE)
```

![](README_files/figure-commonmark/usage-ordered-1.png)

## License

This package is FOSS under MIT License. See the file LICENSE for
details.

## A note on AI helpers

This package was created with the assistance of AI tools, including
Claude Sonnet 4.6 via Perplexity, Gemini Pro 3.1 via Gemini and
Antigravity. `inst/init` contains the jumpstarter prompts used to
conceptualize the package. The main part of the coding was done using
Antigravity. `inst/antigravity` contain the implementation plan and
walkthrough,`inst/antigravity/session.json` contains the session
history. The package logo was created using nanobanana 2 model in
Gemini. The redesign of the palettes following scientific colour best
practices (v0.1.0) was done with Claude Opus 5.5 via Claude Code.
