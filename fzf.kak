##
## fzf.kak by lenormf
##

def -params 4.. -file-completion find-parent-file -docstring 'Assign to a given variable the full path of a file, looked for upwards from a given path' %{ %sh{
    filename="$1"
    variable="${2#*:}"
    variable_scope="${2%%:*}"
    maxdepth="$3"

    shift 3

    function fatal {
        printf %s\\n "echo -color Error %{$@}"
        exit 1
    }

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

## open a pane with an fzf files list to chose from
%sh{
    if [ -n "${TMUX}" ] && which ag 1>/dev/null; then
        printf %s\\n "
            def -params .. -file-completion fzf-open -docstring 'Open a file using the fzf utility' %{ %sh{
                cwd=\$(dirname \${kak_buffile})
                ag -l '.+' \"\${@:-\${cwd}}\" | fzf-tmux -m | while read path; do
                    printf %s\\\\n \"eval -try-client '\${kak_client}' %{edit '\${path}'}\" | kak -p \${kak_session}
                done
            } }

            decl str fzf-cache-filename 'paths'
            decl -hidden str fzf_cache_path
            def -params .. -file-completion fzf-open-cached -docstring 'Open a file using the fzf utility (cached)' %{
                %sh{
                    if [ $# -lt 0 ]; then
                        printf %s\\\\n \"find-parent-file %opt{fzf-cache-filename} global:fzf_cache_path 0 \$@\"
                    else
                        basedir=\$(dirname \"\${kak_buffile}\")
                        printf %s\\\\n \"find-parent-file %opt{fzf-cache-filename} global:fzf_cache_path 0 \${basedir}\"
                    fi
                }

                %sh{
                    if [ -z \"\${kak_opt_fzf_cache_path}\" ]; then
                        exit
                    fi
                    paths_dir=\$(dirname \${kak_opt_fzf_cache_path})
                    fzf-tmux -m < \"\${kak_opt_fzf_cache_path}\" | while read path; do
                        printf %s\\\\n \"eval -try-client '\${kak_client}' %{edit '\${paths_dir}/\${path}'}\" | kak -p \${kak_session}
                    done
                }
            }
        "
    fi
}
