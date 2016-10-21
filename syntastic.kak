##
## syntastic.kak by lenormf
## Auto lint (and optionally format) your code on write
##

decl bool syntastic_autoformat no

def -params 2..3 \
    -docstring %{syntastic-declare-filetype <filetype> <lintcmd> <formatcmd>: automatically lint and/or format buffers on write} \
    syntastic-declare-filetype %{ %sh{
    readonly filetype="$1"

    printf 'hook global WinSetOption filetype=%s %%{\n' "${filetype}"

    if [ "${kak_opt_syntastic_autoformat}" = "true" ]; then
        echo 'hook buffer BufWritePre %val{buffile} %{'

        if [ $# -gt 2 ] && [ -n "$3" ]; then
            printf '%%sh{
                if [ -z "${kak_opt_formatcmd}" ]; then
                    printf "set buffer formatcmd \\"%%s\\"\\\\n" "%s"
                fi
            }\n' "$3"
        fi

        echo 'format }'
    fi

    echo '
        lint-enable
        hook buffer BufWritePost %val{buffile} %{
    '

    if [ -n "$2" ]; then
        printf '%%sh{
            if [ -z "${kak_opt_lintcmd}" ]; then
                printf "set window lintcmd \\"%%s\\"\\\\n" "%s"
            fi
        }\n' "$2"
    fi

    echo 'lint } }'
} }

syntastic-declare-filetype "c" \
    "cppcheck --language=c --enable=all --template='{file}:{line}:1: {severity}: {message}' 2>&1" \
    "clang-format"

syntastic-declare-filetype "cpp" \
    "cppcheck --language=c++ --enable=all --template='{file}:{line}:1: {severity}: {message}' 2>&1" \
    "clang-format"

## FIXME: `dscanner` hasn't been tested
syntastic-declare-filetype "d" \
    "dscanner" \
    "dfmt"

## FIXME: `gometalinter` hasn't been tested
syntastic-declare-filetype "go" \
    "gometalinter" \
    "gofmt -e -s"

syntastic-declare-filetype "python" \
    "pyflakes" \
    "autopep8 -"

## FIXME: no formatter
syntastic-declare-filetype "sh" \
    "shellcheck -fgcc -Cnever"
