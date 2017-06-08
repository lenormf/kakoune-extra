##
## readline.kak by lenormf
## Readline shortcuts implemented in insert mode
##

map -docstring "move the cursor one character to the left" global insert <c-b> <esc>hi
map -docstring "move the cursor one character to the right" global insert <c-f> <esc>li
map -docstring "move the cursor one word to the left" global insert <a-b> <esc>b\;i
map -docstring "move the cursor one word to the right" global insert <a-f> <esc>e\;i
map -docstring "move the cursor to the start of the line" global insert <c-a> <esc>I
map -docstring "move the cursor to the end of the line" global insert <c-e> <esc>gli

map -docstring "delete the character under the anchor" global insert <c-d> <esc>c
map -docstring "delete from the anchor to the start of the line" global insert <c-u> <esc>Ghc
map -docstring "delete from the anchor to the end of the line" global insert <c-k> <esc>Glc
map -docstring "delete until the next word boundary" global insert <a-d> <esc>ec
map -docstring "delete until the previous word boundary" global insert <c-w> <esc>bc

map -docstring "exchange the char before cursor with the character at cursor" global insert <c-t> %{<esc>:try 'exec H<lt>a-k>[^\n][^\n]<lt>ret>\;dp'<ret>i}
map -docstring "exchange the word before cursor with the word at cursor" global insert <a-t> %{<esc>:try 'exec <lt>a-k>\s<lt>ret>e' catch 'exec <lt>a-i>w'<ret><a-;>BS\s+<ret><a-">\;<space>i}
map -docstring "uppercase the current or following word" global insert <a-u> <esc>e<a-i>w~\;i
map -docstring "lowercase the current or following word" global insert <a-l> <esc>e<a-i>w`\;i
map -docstring "capitalize the current or following word" global insert <a-c> <esc>e<a-i>w\;~i

map -docstring "paste after the anchor" global insert <c-y> <esc>pi
