##
## alignr.kak by lenormf
## A minimalist alignment helper
##

## <|>?: align direction (left, right, default left)
## w|W?: remove all whitespace from the selections prior to aligning (before selecting, after selecting, default none)
## \d|\d-\d?|\d(,\d)+?: index of the selection group or splitted group to keep (single number, range, comma separated list)
## s|S: selection method (select, split)
## …: pattern
def -params 1.. -docstring %{alignr [<descriptors>]: align the current selection according to command strings passed in arguments
The descriptors are positional parameters written after the following format:
  <|>?: align direction (left, right, default left)
  w|W?: remove all whitespace from the selections prior to aligning (before selecting, after selecting, default none)
  \d|\d-\d?|\d(,\d)+?: index of the selection group or splitted group to keep (single number, range, comma separated list)
  s|S: selection method (select, split)
  ...: pattern} \
    alignr %{ %sh{
    function _echo {
        printf %s\\n "$@"
    }
    function fatal {
        _echo "echo -color Error %{$@}"
        exit 1
    }

    pattern_idx=1
    for pattern in "$@"; do
        if [ ${#pattern} -lt 2 ]; then
            fatal "Descriptor #${pattern_idx}: invalid pattern length (${#pattern}, expected at least 3)"
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

        ## handle ranges, lists or single numbers
        index=$({
            expr "${pattern}" : '\([0-9]*-[0-9]*\)' \
            || expr "${pattern}" : '\([0-9]*\(,[0-9]*\)*\)';
        } | tr -d '\n')
        if [ -n "${index}" ]; then
            pattern="${pattern#${index}}"
        fi

        action=$(expr "${pattern}" : '\([sS]\)')
        if [ -z "${action}" ]; then
            fatal "Descriptor #${pattern_idx}: invalid action '${action}', expected 's' or 'S'"
        else
            pattern=$(_echo "${pattern#${action}}" | sed -e 's/</<lt>/g' -e 's/;/\;/g')
            if [ -z "${pattern}" ]; then
                fatal "Descriptor #${pattern_idx}: no pattern given"
            fi
        fi

        ## preserve the selection from one pattern to another
        _echo "eval -draft -save-regs '/\"|^@m' %{"

        ## ignore leading whitespace to keep the indentation
        _echo 'try %{ exec <a-s>1s^\h*([^\n]+)<ret> }'

        ## trim multiple whitespace that might come from a previous indentation
        if [ "${trim_whitespace}" = 'w' ]; then
            _echo 'try %{ exec -draft 1s\h(\h+)<ret>d }'
        fi

        ## loop over each line selected
        _echo "eval -draft -itersel %{"

        _echo 'try %{'

        if [ "${action}" = s ] || [ "${action}" = S ]; then
            ## select the parts we want to align
            _echo "exec '${action}${pattern}<ret>'"

            ## an index has been passed to filter out some selections
            if [ -n "${index}" ]; then
## FIXME: [[ is a bashism
                if [[ $index =~ - ]]; then
                    low=$(_echo "${index}" | cut -d- -f1)
                    high=$(_echo "${index}" | cut -d- -f2)

                    if [ -z "${low}" ] || [ -z "${high}" ]; then
                        fatal "Descriptor #${pattern_idx}: invalid empty range"
                    elif [ "${low}" -gt "${high}" ]; then
                        fatal "Descriptor #${pattern_idx}: invalid range (${low} > ${high})"
                    fi

                    _echo "%sh{
                        kept_sel_descs=''
                        i=1
                        for desc in \$(printf '%s\\n' \"\${kak_selections_desc}\" | tr ':' '\\n'); do
                            if [ \$i -ge ${low} ] && [ \$i -le ${high} ]; then
                                if [ -n \"\${kept_sel_descs}\" ]; then
                                    kept_sel_descs=\"\${kept_sel_descs}:\"
                                fi
                                kept_sel_descs=\"\${kept_sel_descs}\${desc}\"
                            fi
                            i=\$((i + 1))
                        done

                        if [ -n \"\${kept_sel_descs}\" ]; then
                            printf '%s\\n' \"select '\${kept_sel_descs}'\"
                        fi
                    }"
## FIXME: [[ is a bashism
                elif [[ $index =~ , ]]; then
                    _echo "%sh{
                        function array_get {
                            arr=\"\${1}\"; sep=\"\${2}\"; i=\"\${3}\";

                            while [ \"\${i}\" -gt 0 ]; do
                                arr=\"\${arr#*\${sep}}\"
                                i=\$((i - 1))
                            done

                            printf '%s\\n' \"\${arr%%\${sep}*}\"
                        }
                        kept_sel_descs=''
                        for idx in \$(printf '%s\\n' \"${index}\" | tr ',' '\\n'); do
                            desc=\$(array_get \"\${kak_selections_desc}\" ':' \"\${idx}\")
                            if [ -n \"\${desc}\" ]; then
                                if [ -n \"\${kept_sel_descs}\" ]; then
                                    kept_sel_descs=\"\${kept_sel_descs}:\"
                                fi
                                kept_sel_descs=\"\${kept_sel_descs}\${desc}\"
                            fi
                        done
                        if [ -n \"\${kept_sel_descs}\" ]; then
                            printf '%s\\n' \"select '\${kept_sel_descs}'\"
                        fi
                    }"
                else
                    if [ "${index}" -eq 0 ]; then
                        ## keep the last selection if the index is zero
                        _echo "exec <space>"
                    else
                        ## a particular group has to be selected
                        _echo "exec '${index}\\' '"
                    fi
                fi
            fi
        fi

        ## trim multiple whitespace that might come from a previous indentation
        if [ "${trim_whitespace}" = 'W' ]; then
            _echo 'try %{ exec -draft 1s\h(\h+)<ret>d }'
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

                ## swap the two if we want to align to the left
                if [ \"${align}\" = '<' ]; then
                    echo 'exec <a-\\;>'
                fi

                ## make sure the cursor is placed after the anchor
                ## swap the two if we want to align to the left
                echo 'exec &'
                echo '}'
            fi
        }"

        _echo '}'

        pattern_idx=$((pattern_idx + 1))
    done
} }
