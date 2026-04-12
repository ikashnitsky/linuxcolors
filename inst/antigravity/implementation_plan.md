# Goal Description

Implement the `LinuxColors` R package extracting visual identities of the most popular Linux distributions for use in data visualization. The package will include standard color palettes, sequential, diverging, and specialized palettes, alongside functions specifically formatted for integration with `ggplot2` (`scale_color_linux` and `scale_fill_linux`).

## User Review Required

Please review the proposed design. I used the hex codes exactly as specified in the markdown report. 
- For the diverging palette (9 colors mentioned), I'll define a 5-color base (`#A80030`, `#E95420`, `#F3F3F3`, `#00D2CF`, `#1793D1`) and `colorRampPalette` will handle expanding it to any required continuous range. 
- I will make `linuxcolors_palettes` an exported list, which is the standard way to expose palettes in R for `paletteer` integration.
Let me know if you would like me to explicitly interpolate the 9 colors for the diverging palette or just provide the 5 key anchor colors.

## Proposed Changes

### `R/` directory (Core logic)

#### [NEW] `R/palettes.R`
Will define and export a master list named `linuxcolors_palettes` containing the following palettes:
- `main` (8 colors)
- `additional` (8 colors)
- `larger` (12 colors)
- `max_paired` (20 colors)
- `diverging` (5 base colors: Debian Red, Ubuntu Orange, Puppy Linux Bone White, CachyOS Teal, Arch Cyan Blue)
- `sequential_green` (5 colors)
- `colorblind_strict` (6 colors)
- `neon` (6 colors)

#### [NEW] `R/scales.R`
Will contain the programmatic implementation for `ggplot2`:
- `linux_palette()`: A color interpolation function for continuous/discrete mapping dynamically.
- `scale_color_linux(palette = "main", discrete = TRUE, reverse = FALSE, ...)`
- `scale_fill_linux(palette = "main", discrete = TRUE, reverse = FALSE, ...)`

### `DESCRIPTION`
#### [MODIFY] `DESCRIPTION`
We will add `ggplot2` into the `Imports` section, as the package provides `ggplot2` scale wrappers. `grDevices` will also be used (for `colorRampPalette`) but it's a base package.

## Open Questions

- Should I add `roxygen2` comments for all exported functions to generate the manual pages? (I plan to run `devtools::document()` so the documentation is built properly).
- For `paletteer`, do you want me to write a small README example showing how to use `paletteer::scale_color_paletteer_d("LinuxColors::main")`?

## Verification Plan

### Automated Tests
1. I will write and run `devtools::document()` to generate documentation and export statements.
2. I will run commands to verify the package can be loaded and that plotting with `ggplot2` and `scale_color_linux` succeeds.

### Manual Verification
- Render a simple R script that generates a `ggplot2` scatter plot and a bar chart using the new color scales.
