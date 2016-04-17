decl str modeline_cur_function

def -hidden curfunc-update %{
    set window modeline_cur_function ''

    eval -draft -save-regs m %{
        reg m %val{cursor_line}
echo -debug %reg{m}

        try %{
            exec <a-?>^#\s*include<ret>J
        } catch %{
            exec Gg
        }

        %sh{
            filetype=$kak_opt_filetype

            case "${filetype}" in
                cpp) filetype=c++;;
                *) exit;;
            esac

            funcdecl=$(printf %s "${kak_selection}" | clang -x "${filetype}" -w -Xclang -ast-dump -fsyntax-only - 2>/dev/null | grep -w FunctionDecl | sed -n '$p')
            if [ -z "${funcdecl}" ]; then
                ## no function was declared before the cursor
                exit
            fi

            ## get the name of the closest declared function from the cursor
            funcname=$(expr "${funcdecl}" : '.* \([a-zA-Z0-9_-]*\) '"'")
            if [ $? -eq 0 ]; then
                ## get the coordinates of the function body
                funcbody=$(expr "${funcdecl}" : '.*:\([0-9]*:[0-9]*, line:[0-9]*:[0-9]*\)>')

                if [ $? -eq 0 ]; then
                    ## FIXME: find a shorter equivalent
                    coords=( $(printf %s "${funcbody}" | sed -e 's/line//' -e 's/<stdin>//' -e 's/,//' -e 's/:/ /g') )
                    cursor_line=$(($kak_reg_m - $kak_cursor_line))

                    ## if the cursor is in the function body, update the function name
                    if [ "${coords[0]}" -le "${cursor_line}" ] && [ "${coords[2]}" -gt "${cursor_line}" ]; then
                        printf %s "eval -client %val{client} %{
                            set window modeline_cur_function '${funcname}'
                        }"
                    fi
                fi
            fi
        }
    }
}

hook global WinCreate .* %{ %sh{
    case "${kak_opt_filetype}" in
        c|cpp|objc) echo 'hook window NormalIdle .* %{ curfunc-update }';;
        *) ;;
    esac
} }
