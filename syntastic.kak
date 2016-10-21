##
## syntastic.kak by lenormf
## Auto lint (and optionally format) your code on write
##

decl bool syntastic_autoformat no

def -hidden -params 3 _syntastic-declare-linter-formatter %{ %sh{
    readonly filetype="$1"

    printf 'hook global WinSetOption filetype=%s %%{\n' "${filetype}"

    if [ "${kak_opt_syntastic_autoformat}" = "true" ]; then
        echo 'hook buffer BufWritePre %val{buffile} %{'

        if [ -n "$3" ]; then
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

_syntastic-declare-linter-formatter "c" \
    "cppcheck --language=c --enable=all --template='{file}:{line}:1: {severity}: {message}' 2>&1" \
    "clang-format"

_syntastic-declare-linter-formatter "cpp" \
    "cppcheck --language=c++ --enable=all --template='{file}:{line}:1: {severity}: {message}' 2>&1" \
    "clang-format"

## FIXME: `dscanner` hasn't been tested
_syntastic-declare-linter-formatter "d" \
    "dscanner" \
    "dfmt"

## FIXME: `gometalinter` hasn't been tested
_syntastic-declare-linter-formatter "go" \
    "gometalinter" \
    "gofmt -e -s"

_syntastic-declare-linter-formatter "python" \
    "pyflakes" \
    "autopep8 -"

## FIXME: no formatter
_syntastic-declare-linter-formatter "sh" \
    "shellcheck -fgcc -Cnever" \
    ""
