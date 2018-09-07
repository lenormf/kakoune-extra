##
## cdmenu.kak for kakoune-extra
## by lenormf
##

declare-user-mode cdmenu

declare-option str-to-str-map cdmenu_paths \
                                        "/=/:/" \
                                        "e=/etc:/etc" \
                                        "g=git root:`git rev-parse --show-toplevel`" \
                                        "h=client $HOME:`printenv kak_client_env_HOME`" \
                                        "H=server $HOME:`printenv HOME`" \
                                        "p=client pwd:`printenv kak_client_env_PWD`" \
                                        "P=server pwd:`printenv PWD`" \
                                        "t=/tmp:/tmp"

define-command -docstring %{
    cdmenu [<index>]: quickly jump to a pre-defined path

Without the <index> argument, a menu listing all available indexes is displayed that allows the user to pick a path interactively.

An index can also be passed directly to the function.
    } cdmenu -params ..1 %{ evaluate-commands %sh{
    : # kak_client_env_HOME, kak_client_env_PWD

    _do() {
        action="$1"; shift
        args="$*"

        eval set -- "${kak_opt_cdmenu_paths}"

        for i in "$@"; do
            key="${i%%=*}"

            case "${action}" in
                get)
                    if [ "${args}" != "${key}" ]; then
                        continue
                    fi

                    path="${i#*:}"

                    if printf %s "${path}" | grep -q '^`.*`$'; then
                        path="${path#\`}"; path="${path%\`}"
                        path=$(eval "${path}")
                    fi

                    printf %s\\n "${path}";;
                map)
                    doc=$(printf "${i}" | sed 's/^[^=]*=//; s/:[^:]*$//; s/~/~~/g')
                    printf 'map -docstring %%~%s~ global cdmenu %s %%{: cdmenu %s<ret>}\n' \
                            "${doc}" "${key}" "${key}";;
            esac
        done
    }

    get_path_index() {
        _do "get" "$1"
    }

    map_indexes() {
        _do "map"
    }

    if [ $# -eq 1 ]; then
        path=$(get_path_index "$1")

        if [ -z "${path}" ]; then
            printf 'echo -markup {Error}Invalid index: %s' "${1}"
            exit 1
        fi

        printf 'cd %%~%s~\n' "$(printf %s "${path}" | sed s/~/~~/g)"
        printf 'echo -markup {Information}Path changed to: %s\n' "${path}"
    else
        map_indexes
        echo enter-user-mode cdmenu
    fi
} }
