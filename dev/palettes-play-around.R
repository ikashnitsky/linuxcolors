tribble(
  ~rank, ~distro,        ~color_name,      ~hex,       ~base,
  # --- Primary 20 ---
  1L,  "CachyOS",        "Teal",           "#00D2CF",  "Arch Linux",
  2L,  "MX Linux",       "Navy Blue",      "#243365",  "Debian/antiX",
  3L,  "EndeavourOS",    "Deep Purple",    "#7B2FBE",  "Arch Linux",
  4L,  "Linux Mint",     "Mint Green",     "#87CF3E",  "Ubuntu/Debian",
  5L,  "Debian",         "Red",            "#A80030",  "Independent",
  6L,  "Manjaro",        "Green",          "#34BE5B",  "Arch Linux",
  7L,  "Ubuntu",         "Orange",         "#E95420",  "Debian",
  8L,  "Fedora",         "Electric Blue",  "#0B57A4",  "Independent",
  9L,  "Arch Linux",     "Cyan Blue",      "#1793D1",  "Independent",
  10L, "Pop!_OS",        "Yellow",         "#FAA41A",  "Ubuntu",
  11L, "Zorin OS",       "Sky Blue",       "#15A6F0",  "Ubuntu",
  12L, "openSUSE",       "Chameleon Green","#73BA25",  "Independent",
  13L, "Kali Linux",     "Steel Blue",     "#367BF0",  "Debian",
  14L, "NixOS",          "Snowflake Blue", "#5277C3",  "Independent",
  15L, "Garuda Linux",   "Flame Orange",   "#E84B4B",  "Arch Linux",
  16L, "elementary OS",  "Sky Blue",       "#64BAFF",  "Ubuntu",
  17L, "KDE Neon",       "Plasma Blue",    "#1D99F3",  "Ubuntu",
  18L, "Void Linux",     "Forest Green",   "#478061",  "Independent",
  19L, "Rocky Linux",    "Emerald Green",  "#10B981",  "RHEL",
  20L, "AlmaLinux",      "Cobalt Blue",    "#1158AE",  "RHEL",
  # --- Reserve 21-40 ---
  21L, "Solus",          "Slate Blue",     "#5294E2",  "Independent",
  22L, "Artix",          "Cyan",           "#00A5CC",  "Arch Linux",
  23L, "Q4OS",           "Light Blue",     "#3BA1D5",  "Debian",
  24L, "TrueNAS",        "Deep Blue",      "#0095D5",  "FreeBSD/Linux",
  25L, "Devuan",         "Dark Grey-Purple","#423D46", "Debian",
  26L, "deepin",         "Ocean Blue",     "#0070FF",  "Debian",
  27L, "antiX",          "Crimson",        "#B30000",  "Debian",
  28L, "Slackware",      "Royal Blue",     "#3869A6",  "Independent",
  29L, "Linux Lite",     "Feather Yellow", "#FFC300",  "Ubuntu",
  30L, "Mageia",         "Cyan-Blue",      "#23A8E0",  "Mandriva",
  31L, "Kubuntu",        "Plasma Blue",    "#0079C1",  "Ubuntu",
  32L, "BigLinux",       "Sky Blue",       "#00B2E1",  "Manjaro",
  33L, "Nobara",         "Purple",         "#8E24AA",  "Fedora",
  34L, "PCLinuxOS",      "Blue",           "#1B5B9E",  "Independent",
  35L, "ArcoLinux",      "Mid Blue",       "#4A86CF",  "Arch Linux",
  36L, "SparkyLinux",    "Leaf Green",     "#5C9A35",  "Debian",
  37L, "Peppermint OS",  "Candy Red",      "#C0353A",  "Debian",
  38L, "Gentoo",         "Deep Violet",    "#54487A",  "Independent",
  39L, "OpenMandriva",   "Ice Blue",       "#00A1DF",  "Mandriva",
  40L, "Mabox Linux",    "Viridian",       "#1ABC9C",  "Manjaro"
)


main <- c(
  "MX Linux" = "#243365",
  "Fedora" = "#0B57A4",
  "CachyOS" = "#00D2CF",
  "pop!os" = "#46bac7",
  "Debian" = "#A80030",
  "Ubuntu" = "#E95420",
  "Manjaro" = "#34BE5B",
  "SparkyLinux" = "#5C9A35",
  "Linux Mint" = "#87CF3E"
)

main_ordered <- c(
  "Debian" = "#A80030",
  "MX Linux" = "#243365",
  "Fedora" = "#0B57A4",
  "Ubuntu" = "#E95420",
  "SparkyLinux" = "#5C9A35",
  "Manjaro" = "#34BE5B",
  "CachyOS" = "#00D2CF",
  "Linux Mint" = "#87CF3E"
)




additional <- c(
  "Garuda Linux" = "#E84B4B",
  "Arch Linux" = "#1793D1",
  "Linux Mint" = "#87CF3E",
  "NixOS" = "#5277C3",
  "openSUSE" = "#73BA25",
  "Zorin OS" = "#15A6F0",
  "Void Linux" = "#478061",
  "KDE Neon" = "#1D99F3"
)

larger <- c(
  "Pop!_OS" = "#faa417", # manual
  "Fedora" = "#0B57A4",
  "Linux Mint" = "#87CF3E",
  "Ubuntu" = "#E95420",
  "EndeavourOS" = "#7B2FBE",
  "MX Linux" = "#243365",
  "CachyOS" = "#00D2CF",
  "Debian" = "#A80030",
  "Arch Linux" = "#1793D1",
  "openSUSE" = "#73BA25",
  "Garuda Linux" = "#E84B4B",
  "KDE Neon" = "#1D99F3"
)

max_paired <- c(
  "Pop!_OS" = "#FAA41A",
  "Ubuntu" = "#E95420",
  "Garuda Linux" = "#E84B4B",
  "Debian" = "#A80030",
  "NixOS" = "#5277C3",
  "EndeavourOS" = "#7B2FBE",
  "Zorin OS" = "#15A6F0",
  "Arch Linux" = "#1793D1",
  "elementary OS" = "#64BAFF",
  "Fedora" = "#0B57A4",
  "KDE Neon" = "#1D99F3",
  "Kali Linux" = "#367BF0",
  "AlmaLinux" = "#1158AE",
  "MX Linux" = "#243365",
  "CachyOS" = "#00D2CF",
  "Rocky Linux" = "#10B981",
  "Linux Mint" = "#87CF3E",
  "Manjaro" = "#34BE5B",
  "openSUSE" = "#73BA25",
  "Void Linux" = "#478061"
)

diverging <- c(
  "Debian" = "#A80030",
  "Ubuntu" = "#E95420",
  "Puppy Linux" = "#F3F3F3",
  "CachyOS" = "#00D2CF",
  "Arch Linux" = "#1793D1"
)

sequential_green <- c(
  "Linux Mint" = "#87CF3E",
  "openSUSE" = "#73BA25",
  "SparkyLinux" = "#5C9A35",
  "Manjaro" = "#34BE5B",
  "Void Linux" = "#478061"
)

colorblind_strict <- c(
  "Pop!_OS" = "#FAA41A",
  "Ubuntu" = "#E95420",
  "Fedora" = "#0B57A4",
  "EndeavourOS" = "#7B2FBE",
  "CachyOS" = "#00D2CF",
  "MX Linux" = "#243365"
)

neon <- c(
  "Garuda Linux" = "#E84B4B",
  "CachyOS" = "#00D2CF",
  "KDE Neon" = "#1D99F3",
  "Zorin OS" = "#15A6F0",
  "Linux Mint" = "#87CF3E",
  "Nobara" = "#8E24AA"
)
