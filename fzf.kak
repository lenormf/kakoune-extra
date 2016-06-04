##
## fzf.kak by lenormf
## Support function for the `fzf` utility
## https://github.com/junegunn/fzf
##

# `fzf-open-cached` requires `find-parent-file` in `utils.kak`

## open a pane with an fzf files list to chose from
%sh{
    if [ -n "${TMUX}" ]; then
        printf %s\\n "
            decl str fzf_filesearch_cmd \"ag -g '' '\%s'\"
            decl str fzf_options '-m'

            def -params .. -file-completion fzf-open -docstring 'Open a file using the fzf utility' %{ %sh{
                cwd=\$(dirname \"\${kak_buffile}\" | sed 's/\\//\\\\\\//g')
                filesearch_cmd=\$(printf '%s\\n' \"\${kak_opt_fzf_filesearch_cmd}\" | sed \"s/%s/\${@:-\${cwd}}/g\")
                eval \"\${filesearch_cmd}\" | fzf-tmux \${kak_opt_fzf_options} | while read path; do
                    printf %s\\\\n \"eval -try-client '\${kak_client}' %{edit '\${path}'}\" | kak -p \${kak_session}
                done
            } }

            decl str fzf_cache_filename 'paths'
            decl -hidden str fzf_cache_path
            def -params .. -file-completion fzf-open-cached -docstring 'Open a file using the fzf utility (cached)' %{
                %sh{
                    if [ $# -lt 0 ]; then
                        printf %s\\\\n \"find-parent-file %opt{fzf_cache_filename} global:fzf_cache_path 0 \$@\"
                    else
                        basedir=\$(dirname \"\${kak_buffile}\")
                        printf %s\\\\n \"find-parent-file %opt{fzf_cache_filename} global:fzf_cache_path 0 \${basedir}\"
                    fi
                }

                %sh{
                    if [ -z \"\${kak_opt_fzf_cache_path}\" ]; then
                        exit
                    fi
                    paths_dir=\$(dirname \${kak_opt_fzf_cache_path})
                    fzf-tmux \${kak_opt_fzf_options} < \"\${kak_opt_fzf_cache_path}\" | while read path; do
                        printf %s\\\\n \"eval -try-client '\${kak_client}' %{edit '\${paths_dir}/\${path}'}\" | kak -p \${kak_session}
                    done
                }
            }
        "
    fi
}
