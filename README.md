# **linuxcolors: color palettes from the identity colors of the most popular Linux distros** <a href='https://github.com/ikashnitsky/linuxcolors'><img src='inst/logo/logo-linuxcolors-small.png' align="right" width="20%" min-width="200px"/></a>
  
![](inst/logo/logo-card.png)  

## Installation

```r
# Install from GitHub
pak::pak("ikashnitsky/linuxcolors")
```

## Usage

```r
library(linuxcolors)

# Get the main palette
linux_palette("main")(5)

# Get the additional palette
linux_palette("additional")(5)
```

## License

This package is FOSS under MIT License. See the file LICENSE for details.

## A note on AI helpers 

This package was created with the assistance of AI tools, including Claude Sonnet 4.6 via Perplexity, Gemini Pro 3.1 via Gemini and Antigravity. `inst/init` contains the jumpstarter prompts used to conceptualize the package. The main part of the coding was done using Antigravity. `inst/antigravity` contain the i plementation plan and walkthrough,`inst/antigravity/session.json` contains the session history. The package logo was created using nanobanana 2 model in Gemini.
