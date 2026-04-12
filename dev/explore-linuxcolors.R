library(tidyverse)
library(linuxcolors)
library(prismatic)
library(colorspace)


linuxcolors_palettes$main |>color() |> plot()

linuxcolors_palettes$additional |> color() |> plot()

linuxcolors_palettes$larger |> color() |> plot()

linuxcolors_palettes$max_paired |> color() |> plot()

linuxcolors_palettes$diverging |> color() |> plot()

linuxcolors_palettes$sequential_green |> color() |> plot()

linuxcolors_palettes$colorblind_strict |> color() |> plot()
linuxcolors_palettes$colorblind_strict |> color() |> check_color_blindness()

linuxcolors_palettes$neon |> color() |> plot()

