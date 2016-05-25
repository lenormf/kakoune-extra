##
## fzf.kak by lenormf
##

# requires `find-parent-file` in `utils.kak`

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
