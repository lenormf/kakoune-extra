##
## lineindent.kak by lenormf
## Align a line with the previous/next, across empty ones
##

## FIXME: use command counts whenever available
def -params 1 \
-docstring %{lineindent <offset>: indent the current selection using a remote line as reference
The offset argument is an integer that indicates the number of the reference line, but can be prefixed with the following:
  - '-': indent with the previous non empty line, e.g. -2 for second line above the current selection
  - '+': indent with the next non empty line, e.g. +3 for the third line beneath the current selection} \
    lineindent %{ %sh{
    pattern_align=''
    n=$(expr "$1" : '\([+-]*[0-9]*\)')
    case "$1" in
        -[0-9]*) pattern_align="${n}<a-/>^\\h*[^\\n]+\\n+<ret>";;
        +[0-9]*) pattern_align="${n}/^\\h*[^\\n]+\\n+<ret>";;
        [0-9]*) pattern_align="${n}g";;
        *) exit;;
    esac

    printf %s\\n "eval -draft -save-regs '/\"|^@' %{
        exec Z ${pattern_align} I<esc><a-z> <a-&>
    }"
} }
