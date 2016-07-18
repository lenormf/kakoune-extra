##
## focus.kak by lenormf
## Store the focus state of the current window
##

## Markup string, empty when the window is focused
decl str modeline_focus

hook global FocusIn .* %{ %sh{
    printf %s "set window modeline_focus ''"
} }

hook global FocusOut .* %{ %sh{
    printf %s "set window modeline_focus '{StatusCursor}blurred{StatusLine}'"
} }
