##
## openelec.kak by lenormf
## Highlight package files in an OpenElec file tree
##

hook global BufCreate .*/?package\.mk %{ %sh{
    path=$(readlink -f "${kak_buffile}")
    if printf %s "${path}" | grep -q "/packages/"; then
        echo 'set buffer filetype sh'
    fi
} }
