##
## alignr.kak by lenormf
## A minimalist alignment helper
##

## <|>?: align direction (left, right, default left)
## w?: remove all whitespace from the selections prior to aligning (default no)
## \d?: index of the selection group or splitted group to keep
## s|S: selection method (select, split)
## …: pattern
def -params 1.. alignr -docstring 'Align the current selection according to command strings passed in arguments' %{ %sh{
    function _echo {
        printf %s\\n "$@"
    }
    function fatal {
        _echo "echo -color Error %{$@}"
        exit 1
    }

    for pattern in "$@"; do
        if [ ${#pattern} -lt 2 ]; then
            fatal "Invalid pattern length (${#pattern}, expected at least 3)"
        fi

        ## parse the current argument
        align=$(expr "${pattern}" : '\(.\)')
        if ! echo '<>' | grep -q "${align}"; then
            align='<'
        else
            pattern="${pattern#${align}}"
        fi

        trim_whitespace=$(expr "${pattern}" : '\(.\)')
        if ! echo 'w' | grep -q "${trim_whitespace}"; then
            trim_whitespace=''
        else
            pattern="${pattern#${trim_whitespace}}"
        fi

        index=$(expr "${pattern}" : '\([0-9]*\)')
        if [ -n "${index}" ]; then
            pattern="${pattern#${index}}"
        fi

        action=$(expr "${pattern}" : '\(.\)')
        if ! echo 'sS' | grep -q "${action}"; then
            fatal "Invalid action '${action}', expected 's' or 'S'"
        else
            pattern=$(_echo "${pattern#${action}}" | sed -e 's/</<lt>/g' -e 's/;/\;/g')
        fi

        _echo "eval -draft -save-regs '/\"|^@m' %{"

        ## ignore leading whitespace to keep the indentation
        _echo 'try %{ exec <a-s>1s^\s*(.+)<ret> }'

        ## trim multiple whitespace that might come from previous indentation
        ## we assume that a single whitespace character was placed intentionally
        ## and has to be kept
        if [ -n "${trim_whitespace}" ]; then
            _echo 'try %{ exec -draft 1s\s(\s+)<ret>d }'
        fi

        ## empty out the selections register before use
        _echo 'reg m ""'

        ## loop over each line selected
        _echo "eval -draft -itersel %{"

        _echo 'try %{'

        if [ "${action}" = s ]; then
            ## select the parts we want to align
            if [ -z "${index}" ]; then
                ## no index was passed, select all we can
                _echo "exec s${pattern}<ret>"
            else
                ## a particular group has to be selected, just use the search command
                _echo "exec <a-:><a-\;>\;${index}/${pattern}<ret>"
            fi
        else
            ## split to get the parts we want to align
            if [ -z "${index}" ]; then
                ## no index was passed, perform a regular split
                _echo "exec S${pattern}<ret>"
            else
                ## FIXME
                ## a particular group has to be selected
                echo -n
            fi
        fi

        _echo "%sh{
            if [ -n \"\${kak_reg_m}\" ]; then
                echo 'reg m \"%reg{m}:%val{selections_desc}\"'
            else
                echo 'reg m \"%val{selections_desc}\"'
            fi
        }"

        _echo '}'
        _echo '}'

        _echo 'try %{'

        ## restore the selections captured in the draft
        _echo "select \"%reg{m}\""

        ## make sure the cursor is placed after the anchor
        ## swap the two if we want to align to the left
        _echo 'exec <a-:>'
        if [ "${align}" = '<' ]; then
            _echo 'exec <a-\;>'
        fi

        ## align
        _echo 'exec &'

        _echo '}'
        _echo '}'
    done
} }
