##
## riotjs.kak by lenormf
##

# http://www.riotjs.com/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .+\.tag %{
    set buffer filetype riotjs
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

addhl -group / regions riotjs \
    partial '^\s+<' '$' '' \
    model '^\s+[^<]' '$' ''

addhl -group /riotjs/model ref javascript
addhl -group /riotjs/partial ref html

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=riotjs %{
    addhl ref riotjs
}

hook global WinSetOption filetype=(?!riotjs).* %{
    rmhl riotjs
}
