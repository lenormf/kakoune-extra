##
## pkgbuild.kak by lenormf
## Highlight Archlinux package files
##

hook global BufCreate .*/?PKGBUILD %{
    set buffer filetype sh
}
