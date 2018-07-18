##
## syntastic.kak by lenormf
## Auto lint (and optionally format) your code on write
##

declare-option -docstring "format the buffer on save" \
    bool syntastic_autoformat no

define-command -params 2..3 \
    -docstring %{syntastic-declare-filetype <filetype> <lintcmd> <formatcmd>: automatically lint and/or format buffers on write} \
    syntastic-declare-filetype %{ evaluate-commands %sh{
    readonly filetype="$1"

    printf 'hook global WinSetOption filetype=%s %%{\n' "${filetype}"

    if [ $# -gt 2 ] && [ -n "$3" ]; then
        printf 'hook buffer BufWritePre "\Q%%val{buffile}" %%{ eval %%sh{
            if [ "${kak_opt_syntastic_autoformat}" = true ]; then
                if [ -z "${kak_opt_formatcmd}" ]; then
                    printf "set buffer formatcmd \\"%%s\\"\\\\n" "%s"
                fi
                echo format
            fi
        } }\n' "$(printf %s "$3" | sed -e 's/\([%"]\)/\1\1/g' -e 's/"/\\"/g')"
    fi

    ## FIXME: try isn't the good solution, this has to be executed only once
    echo '
        try %{ lint-enable }
        hook buffer BufWritePost "\Q%val{buffile}" %{
    '

    if [ -n "$2" ]; then
        printf 'eval %%sh{
            if [ -z "${kak_opt_lintcmd}" ]; then
                printf "set window lintcmd \\"%%s\\"\\\\n" "%s"
            fi
        }\n' "$(printf %s "$2" | sed -e 's/\([%"]\)/\1\1/g' -e 's/"/\\"/g')"
    fi

    echo 'lint } }'
} }

syntastic-declare-filetype "c" \
    'cppcheck --language=c --enable=all --template="{file}:{line}:1: {severity}: {message}" 2>&1' \
    'clang-format'

syntastic-declare-filetype "cpp" \
    'cppcheck --language=c++ --enable=all --template="{file}:{line}:1: {severity}: {message}" 2>&1' \
    'clang-format'

## FIXME: `dscanner` doesn't allow formatting the output yet
syntastic-declare-filetype "d" \
    'dscanner -S' \
    'dfmt'

## FIXME: `gometalinter` only takes directories as argument, create a wrapper
syntastic-declare-filetype "go" \
    'gometalinter' \
    'gofmt -e -s'

## NOTE: ignore all default errors/warnings documented in the man page, plus lines too long (E501)
syntastic-declare-filetype "python" \
    'flake8 --filename=* --format="%(path)s:%(row)d:%(col)d: error: %(text)s" --ignore=E121,E123,E126,E226,E24,E704,W503,W504,E501' \
    'autopep8 -'

syntastic-declare-filetype "sh" \
    'shellcheck -fgcc -Cnever'
