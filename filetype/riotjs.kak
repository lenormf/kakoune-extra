##
## riotjs.kak by lenormf
##

# http://www.riotjs.com/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .+\.tag %{
    set-option buffer filetype riotjs
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/ regions riotjs \
    partial '^\s+<' '$' '' \
    model '^\s+[^<]' '$' ''

add-highlighter shared/riotjs/model ref javascript
add-highlighter shared/riotjs/partial ref html

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=riotjs %{
    add-highlighter window ref riotjs
}

hook global WinSetOption filetype=(?!riotjs).* %{
    remove-highlighter window/riotjs
}
