##
## sdl.kak by lenormf
##

# https://github.com/Abscissa/SDLang-D/wiki/Language-Guide
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*/?.+\.sdl %{
    set-option buffer filetype sdl
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

# Regions

add-highlighter shared/sdl regions
add-highlighter shared/sdl/code default-region group
add-highlighter shared/sdl/double_string region %{(?<!\\)(\\\\)*\K"} %{(?<!\\)(\\\\)*"} fill string
add-highlighter shared/sdl/comment region /\* \*/ fill comment
add-highlighter shared/sdl/comment_inline region (//|--|#) $ fill comment
add-highlighter shared/sdl/verbatim_string region ` ` fill meta

# Grammar
add-highlighter shared/sdl/code/ regex ^\h*((?<namespace>[_\w][\w_$.-]*):)?(?<identifier>[_\w][\w_$.-]*) namespace:attribute identifier:keyword
add-highlighter shared/sdl/code/ regex ((?<namespace>[_\w][\w_$.-]*):)?(?<identifier>[_\w][\w_$.-]*)(?<equal>=) namespace:attribute identifier:attribute equal:operator
add-highlighter shared/sdl/code/ regex (\d*\.?\d+)([lL]|[fF]|[bB]?[dD])? 0:value
add-highlighter shared/sdl/code/ regex \b(true|false|null)\b 0:value
add-highlighter shared/sdl/code/ regex \b\d{4}/(0\d|1[0-2])/([0-2]\d|3[0-1])(\h([0-1]\d|2[0-3]):[0-5]\d(:([0-5]\d))?(\.\d{3})?(-[A-Z]+(\+([0-1]\d|2[0-3])(:[0-5]\d)?)?)?)?\b 0:value
add-highlighter shared/sdl/code/ regex \b(\d+d:)?([0-1]\d|2[0-3]):([0-5]\d):[0-5]\d(\.\d{3})?\b 0:value
add-highlighter shared/sdl/code/ regex \[[^\]]+\] 0:value

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=sdl %{
    add-highlighter window/sdl ref sdl
}
hook global WinSetOption filetype=(?!sdl).* %{
    remove-highlighter window/sdl
}
