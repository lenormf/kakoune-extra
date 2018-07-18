##
## clearsilver.kak by lenormf
##

# http://www.clearsilver.net/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .+\.cst %{
    set-option buffer filetype clearsilver
}

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/clearsilver regions
add-highlighter shared/clearsilver/code default-region group
add-highlighter shared/clearsilver/inline_cs region '<\?cs\b' '\?>' regions
add-highlighter shared/clearsilver/inline_cs/code default-region group

add-highlighter shared/clearsilver/code/ ref html

add-highlighter shared/clearsilver/inline_cs/string_double region '"' (?<!\\)(\\\\)*" fill string
add-highlighter shared/clearsilver/inline_cs/string_simple region "'" "'" fill string

add-highlighter shared/clearsilver/inline_cs/code/ regex '(<\?cs\b)|(\?>)' 0:magenta
add-highlighter shared/clearsilver/inline_cs/code/ regex \b[+-]?(0x\w+|#?\d+)\b 0:value
add-highlighter shared/clearsilver/inline_cs/code/ regex \b(subcount|name|first|last|abs|max|min|string.slice|string.find|string.length|_)\( 1:keyword
add-highlighter shared/clearsilver/inline_cs/code/ regex \b(var|evar|lvar|include|linclude|set|name|if|else|elif|alt|each|loop|with|def|call): 1:attribute
add-highlighter shared/clearsilver/inline_cs/code/ regex /if\b 0:attribute

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=clearsilver %{
    add-highlighter window/clearsilver ref clearsilver
}
hook global WinSetOption filetype=(?!clearsilver).* %{
    remove-highlighter window/clearsilver
}
