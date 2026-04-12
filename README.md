

# **linuxcolors: color palettes from the identity colors of the most popular Linux distros** <a href='https://github.com/ikashnitsky/linuxcolors'><img src='inst/logo/logo-linuxcolors-small.png' align="right" width="20%" min-width="200px"/></a>

![](inst/logo/logo-card.png)

## Installation

``` r
# Install from GitHub
pak::pak("ikashnitsky/linuxcolors")
```

## Usage

``` r
library(tidyverse)
library(linuxcolors)


# Discrete color scale example
swiss |>
  ggplot(
    aes(x = Agriculture, y = Fertility, color = Catholic > 50)
  ) +
  geom_point(size = 3) +
  stat_ellipse()+
  scale_color_linux("neon")


# Discrete fill scale example
swiss |> 
  mutate(Religion = ifelse(Catholic > 50, "Catholic", "Protestant")) |>
  ggplot(aes(x = Fertility, fill = Religion)) +
  geom_density(alpha = 0.7) +
  scale_fill_linux("main")

# Continuous color scale example
swiss |>
  ggplot(aes(x = Agriculture, y = Fertility, color = Education)) +
  geom_point(size = 3) +
  scale_color_linux("diverging", discrete = FALSE)
```

## License

This package is FOSS under MIT License. See the file LICENSE for
details.

## A note on AI helpers

This package was created with the assistance of AI tools, including
Claude Sonnet 4.6 via Perplexity, Gemini Pro 3.1 via Gemini and
Antigravity. `inst/init` contains the jumpstarter prompts used to
conceptualize the package. The main part of the coding was done using
Antigravity. `inst/antigravity` contain the i plementation plan and
walkthrough,`inst/antigravity/session.json` contains the session
history. The package logo was created using nanobanana 2 model in
Gemini.
