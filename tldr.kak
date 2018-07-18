declare-option -hidden str tldr_index_url "http://tldr.sh/assets/index.json"
declare-option -hidden str tldr_page_url "https://raw.githubusercontent.com/tldr-pages/tldr/master/pages"

define-command -hidden -params 2 tldr-open %{
    edit! -scratch "*tldr:%arg{1}*"
    set-option buffer filetype markdown
    execute-keys \%d "!curl -sL '%opt{tldr_page_url}/%arg{2}/%arg{1}.md'<ret>"
}

define-command -params 1..2 -shell-candidates %{
    curl -sL "${kak_opt_tldr_index_url}" | jq -r '.commands[] | .name'
} -docstring %{
tldr <command> [platform]: open a new buffer with a TL;DR for the given command

The optional platform argument can be one of the following:
  - osx
  - linux
  - sunos
  - common
} tldr %{ evaluate-commands %sh{
    command="$1"

    if [ $# -lt 2 ]; then
        case $(uname -s) in
            Darwin) platform="osx";;
            Linux) platform="linux";;
            SunOS) platform="sunos";;
            *) platform="common";;
        esac

        curl -sL "${kak_opt_tldr_index_url}" \
            | jq -r --arg command "${command}" '.commands[] | select(.name==$command) | .platform[]' \
            | while read -r p; do
                printf 'tldr-open "%s" "%s"\n' "${command}" "${p}"
            done
    else
        platform="$2"
        if ! expr "${platform}" : '\(osx\|linux\|sunos\|common\)$' >/dev/null; then
            echo 'echo -markup {Error}Unsupported platform'
            exit 1
        else
            printf 'tldr-open "%s" "%s"\n' "${command}" "${platform}"
        fi
    fi
} }
