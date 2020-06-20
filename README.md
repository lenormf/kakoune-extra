# Archived

This repository is not being maintained any more, and doesn't accept further
user contributions.

The highlighters have been moved to the
[kakoune-extra-filetypes](https://github.com/kakoune-editor/kakoune-extra-filetypes)
repository, which is bigger, maintained and accept user contributions.

Commands remain here for the sake of posterity. Feel free to
grave dig any files and make them work with more recent version of
[kakoune]("https://github.com/mawww/kakoune").

# kakoune-extra

This repository contains several scripts for the
[kakoune]("https://github.com/mawww/kakoune") code editor that were not
eligible to be merged with the core scripts that kakoune ships with, but
still implement useful experimental features or allow highlighting of custom
file formats.

Scripts are all fairly well commented, but those whose use require more
than a quick sentence in an inlined comment have their own `.asciidoc`
documentation file (e.g. `fzf.asciidoc`).

## Versioning

The `master` branch is compatible with the latest stable version of the
editor, while the `dev` branch targets the latest `HEAD`, for users who
use the Git version.

## How to use the scripts

### System wide availability

Drop the scripts relevant to your interest in the `/usr/share/kak/rc`
directory. They will be automatically loaded everytime a new `kak` process
is started.

### Per user availability

Copy the scripts you want to have autoloaded in the `$XDG_CONFIG_HOME/kak/rc`
directory. They will be automatically loaded everytime a new `kak` process
is started.

### Keeping scripts up to date

If you want to be able to update the scripts easily, clone this repository
and create symbolic links to the scripts you want to have loaded automatically
in the system/user rc directory (c.f. previous points).

## Categories

The scripts that are in the root directory of the repository are general
purpose, while the following categories hold scripts with particular uses.

### Filetypes

Support for filetypes that are not handled by the upstream version.

### Games

Small games to pass time, with minimal dependencies.

### Widgets

Placed in the `widgets` directory, those scripts store information in
variables whose prefix is `modeline_`. As their name suggest, they are aimed
at being used in the `modelinefmt` variable, and hold specific information.

Example: the `percent` widget will update the `modeline_pos_percent`
option with the relative position of the cursor in the buffer (using a
percentage). You can use it by either inserting `%opt{modeline_pos_percent}%`
variable in `modelinefmt`, or directly in a script or yours.

## Contributing

Feel free to create a pull request if you want to share a useful script.

## License

All the scripts in this repository are UNLICENSE'd.
