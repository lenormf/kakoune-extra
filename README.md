# kakoune-extra

This repository contains several scripts for the [kakoune]("https://github.com/mawww/kakoune") code editor
that were not elligible to be merged with the core scripts that kakoune ships with, but still implement
useful experimental features or allow highlighting of custom file formats.

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

## Contributing

Feel free to create a pull request if you want to share a useful script.
