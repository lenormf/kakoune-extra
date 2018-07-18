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

add-highlighter shared/riotjs regions
add-highlighter shared/riotjs/partial region '^\s+<' '$' ref html
add-highlighter shared/riotjs/model region '^\s+[^<]' '$' ref javascript

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=riotjs %{
    add-highlighter window/riotjs ref riotjs
}

hook global WinSetOption filetype=(?!riotjs).* %{
    remove-highlighter window/riotjs
}
