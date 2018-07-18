##
## pkgbuild.kak by lenormf
## Highlight Archlinux package files
##

hook global BufCreate .*/?PKGBUILD %{
    set-option buffer filetype sh
}
