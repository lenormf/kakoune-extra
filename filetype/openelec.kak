##
## openelec.kak by lenormf
## Highlight package files in an OpenElec file tree
##

hook global BufCreate .+ %{ %sh{
    path=$(readlink -e "${kak_buffile}")
    filename="${path##*/}"
    if printf %s "${path}" | grep -q "/packages/" \
       && [ "${filename}" = "package.mk" ]; then
        echo 'set buffer filetype sh'
    fi
} }
