# linuxcolors 0.1.0

## Palettes redesigned following scientific colour best practices

The palettes were rebuilt following Crameri, Shephard & Heron (2020),
*The misuse of colour in science communication*.

* Qualitative: `main` (8 colours) and `neon` (5 bright colours for dark
  backgrounds). Both are chosen among the brand colours to keep the colours
  distinct under deuteranopia, protanopia and tritanopia. The colours are
  ordered so that the first *k* are always well separated.
* Sequential (new): `ubuntu`, `arch`, `mint`, `distrohop`. Lightness (CIE L*)
  is linear and monotonic, so the order survives greyscale printing and CVD.
* Diverging (new): `fedora_redhat`, `pop`, `ubuntu_mint`. Their arms have
  exactly mirrored lightness around a light, neutral centre.
* Removed `additional`, `larger`, `max_paired`, `colorblind_strict`,
  `diverging` and `sequential_green`. They contained near-identical colours
  or had non-monotonic lightness. Using one of these names now gives a
  warning and its closest replacement.
* New `linux_distro_colors`: the raw brand colours of 37 distros.

## Functions

* New `linux_colors()` / `linux_colours()` extract `n` colours. Qualitative
  palettes are never interpolated; requesting more colours than they have is
  an error. Sequential and diverging palettes are interpolated in OKLab, not
  sRGB.
* New `linux_palettes_info()` and `show_linux_palettes()`.
* `scale_colour_linux()` (alias `scale_color_linux()`) and
  `scale_fill_linux()` now pick discrete vs continuous from the palette type.
  They gain a `midpoint` argument to centre diverging palettes, and an
  `aesthetics` argument. They no longer use the deprecated `scale_name`
  argument of `ggplot2::discrete_scale()`.
