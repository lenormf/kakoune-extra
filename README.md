# kakoune-extra

This repository contains several scripts for the [kakoune]("https://github.com/mawww/kakoune") code editor
that were not eligible to be merged with the core scripts that kakoune ships with, but still implement
useful experimental features or allow highlighting of custom file formats.

Scripts are all fairly well commented, but those whose use require more than a quick sentence in an inlined
comment have their own `.asciidoc` documentation file (e.g. `fzf.asciidoc`).

## How to use the scripts

### System wide availability

Drop the scripts relevant to your interest in the `/usr/share/kak/rc` directory. They will be automatically
loaded everytime a new `kak` process is started.

### Per user availability

Copy the scripts you want to have autoloaded in the `$XDG_CONFIG_HOME/kak/rc` directory. They will be automatically
loaded everytime a new `kak` process is started.

### Keeping scripts up to date

If you want to be able to update the scripts easily, clone this repository and create symbolic links to the scripts
you want to have loaded automatically in the system/user rc directory (c.f. previous points).

## Categories

The scripts that are in the root directory of the repository are general purpose, while the following categories
hold scripts with particular uses.

### Widgets

Placed in the `widgets` directory, those scripts store information in variables whose prefix is `modeline-`. As
their name suggest, they are aimed at being used in the `modelinefmt` variable, and hold specific information.

Example: the `percent` widget will update the `modeline-pos-percent` option with the relative position of the cursor
in the buffer (using a percentage). You can use it by either inserting `%opt{modeline-pos-percent}%` variable
in `modelinefmt`, or directly in a script or yours.

## Contributing

Feel free to create a pull request if you want to share a useful script.

## License

All the scripts in this repository are UNLICENSE'd.
