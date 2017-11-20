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

add-highlighter shared/ regions -default code clearsilver \
    inline_cs '<\?cs' '\?>' ''

add-highlighter shared/clearsilver/code ref html

add-highlighter shared/clearsilver/inline_cs regions content \
    string '"' (?<!\\)(\\\\)*"      '' \
    string "'" "'"                  ''

add-highlighter shared/clearsilver/inline_cs/content/string fill string

add-highlighter shared/clearsilver/inline_cs regex '(<\?cs)|(\?>)' 0:magenta
add-highlighter shared/clearsilver/inline_cs regex \b[+-]?(0x\w+|#?\d+)\b 0:value
add-highlighter shared/clearsilver/inline_cs regex (subcount|name|first|last|abs|max|min|string.slice|string.find|string.length|_)\( 1:keyword
add-highlighter shared/clearsilver/inline_cs regex (var|evar|lvar|include|linclude|set|name|if|else|elif|alt|each|loop|with|def|call): 1:attribute
add-highlighter shared/clearsilver/inline_cs regex /if 0:attribute

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=clearsilver %{
    add-highlighter window ref clearsilver
}
hook global WinSetOption filetype=(?!clearsilver).* %{
    remove-highlighter window/clearsilver
}
