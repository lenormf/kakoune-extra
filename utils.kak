##
## utils.kak by lenormf
##

def -params 4.. -file-completion \
    -docstring %{find-parent-file <filename> <scope:name> <depth> <dirs>: assign to a given variable the full path of a file, looked for upwards from a given path
The dirs parameter is a list of one or more directories which the function will traverse in order} \
    find-parent-file %{ %sh{
    filename="$1"
    variable="${2#*:}"
    variable_scope="${2%%:*}"
    maxdepth="$3"

    shift 3

    function fatal {
        printf %s\\n "echo -color Error %{$@}"
        exit 1
    }

    ## FIXME: backup the old value in the variable, and restore it after looking up the file
    printf %s\\n "set '${variable_scope}' '${variable}' ''"
    if [ -z "${filename}" ]; then
        fatal "first argument: filename needed"
    elif [ -z "${variable}" ] || ! echo "window buffer global current" | grep -qiw "${variable_scope}"; then
        fatal "second argument: syntax expected: \"scope:name\""
    elif ! [[ $maxdepth =~ [0-9]+ ]]; then
        fatal "third argument: maximum depth of recursion needed"
    fi

    for basedir in "$@"; do
        if [ ! -d "${basedir}" ]; then
            fatal "no such directory: \"${basedir}\""
        fi

        n_depth=0
        while true; do
            n_depth=$((n_depth + 1))
            current_path=$(readlink -e "${basedir}/${filename}")

            if [ -f "${basedir}/${filename}" ]; then
                printf %s\\n "set '${variable_scope}' '${variable}' '${current_path}'"
                exit
            elif [ "${basedir}" = / ]; then
                break
            elif [ "${n_depth}" -ge "${maxdepth}" ] && [ "${maxdepth}" -gt 0 ]; then
                break
            fi

            basedir="${basedir}/.."
        done
    done
} }
