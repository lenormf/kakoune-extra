##
## alignr.kak by lenormf
## A minimalist alignment helper
##

## <|>?: align direction (left, right, default left)
## w|W?: remove all whitespace from the selections prior to aligning (before selecting, after selecting, default none)
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
        align=$(expr "${pattern}" : '\([<>]\)')
        if [ -z "${align}" ]; then
            align='<'
        else
            pattern="${pattern#${align}}"
        fi

        trim_whitespace=$(expr "${pattern}" : '\([wW]\)')
        if [ -z "${trim_whitespace}" ]; then
            trim_whitespace=''
        else
            pattern="${pattern#${trim_whitespace}}"
        fi

        index=$(expr "${pattern}" : '\([0-9]*\)')
        if [ -n "${index}" ]; then
            pattern="${pattern#${index}}"
        fi

        action=$(expr "${pattern}" : '\([sS]\)')
        if [ -z "${action}" ]; then
            fatal "Invalid action '${action}', expected 's' or 'S'"
        else
            pattern=$(_echo "${pattern#${action}}" | sed -e 's/</<lt>/g' -e 's/;/\;/g')
        fi

        _echo "eval -draft -save-regs '/\"|^@m' %{"

        ## ignore leading whitespace to keep the indentation
        _echo 'try %{ exec <a-s>1s^\s*([^\n]+)<ret> }'

        ## trim multiple whitespace that might come from a previous indentation
        if [ "${trim_whitespace}" = 'w' ]; then
            _echo 'try %{ exec -draft s\s+<ret>d }'
        fi

        ## empty out the selections register before use
        _echo 'reg m ""'

        ## loop over each line selected
        _echo "eval -draft -itersel %{"

        _echo 'try %{'

        if [ "${action}" = s ] || [ "${action}" = S ]; then
            ## select the parts we want to align
            _echo "exec '${action}${pattern}<ret>'"

            if [ -n "${index}" ]; then
                ## a particular group has to be selected
                _echo "exec '${index}\\' '"
            fi
        fi

        ## trim multiple whitespace that might come from a previous indentation
        if [ "${trim_whitespace}" = 'W' ]; then
            _echo 'try %{ exec -draft s\s+<ret>d }'
        fi

        ## save the selections to apply them after the parent draft
        _echo "%sh{
            if [ -n \"\${kak_reg_m}\" ]; then
                echo 'reg m \"%reg{m}:%val{selections_desc}\"'
            else
                echo 'reg m \"%val{selections_desc}\"'
            fi
        }"

        _echo '}'

        _echo '}'

        ## make sure that we have selections to align, and align them
        _echo "%sh{
            if [ -n \"\${kak_reg_m}\" ]; then
                ## restore the selections captured in the draft
                ## and make sure the anchor is set prior to the cursor
                echo 'try %{
                    select \"%reg{m}\"
                    exec <a-:>
                '

                if [ \"${align}\" = '<' ]; then
                    echo 'exec <a-\\;>'
                fi

                ## make sure the cursor is placed after the anchor
                ## swap the two if we want to align to the left
                echo 'exec &
                }'
            fi
        }"

        _echo '}'
    done
} }
