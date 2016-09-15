##
## line_indent.kak by lenormf
## Align a line with the previous/next, across empty ones
##

# Align the current line if a valid modifier has been selected
# Do nothing otherwise, but clear out the statusline of any message before exiting
def -hidden _line_indent_modifier %{ %sh{
    function _echo {
        printf %s\\n "$@"
    }

    pattern_align=''
    case "${kak_reg_m}" in
        -) pattern_align='I<esc><a-?>\S[^\n]+<ret><a-s>'"'";;
        +) pattern_align='I<esc>J?\S<ret><a-s>';;
        *) _echo 'echo ""'; exit;;
    esac

    _echo "eval -draft %{
        exec ${pattern_align} <a-&>
        try %{ exec <a-x>1s^(\h+)\n<ret>d }
    }
    echo ''
    "
} }

# Print a message and wait for a key to be hit
def -hidden _line_indent %{ eval -save-regs m %{
    echo -color Information 'Hit either "-" or "+" to align the current line, cancel with any other key'
    onkey m _line_indent_modifier
} }

# After hitting `=`, the following modifiers can be used:
# '-': align with the previous non-empty line
# '+': align with the next non-empty line
map global normal = :_line_indent<ret>
