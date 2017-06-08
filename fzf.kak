##
## fzf.kak by lenormf
## Support function for the `fzf` utility
## https://github.com/junegunn/fzf
##

# `fzf-cached` requires `find-parent-file` in `utils.kak`

decl -docstring %{formatted shell command whose output is passed to `fzf` to generate a list of tokens
Each occurence of the `%s` string will be replaced with the directory to list} \
    str fzf_filesearch_cmd 'ag -g "" "%s"'
decl -docstring "options passed to `fzf` when listing a directory" \
    str fzf_options '-m'
decl -docstring "name of the cache filename looked for by the `fzf-cached` command" \
    str fzf_cache_filename 'paths'

decl -hidden str fzf_cache_path

def -params .. -file-completion \
    -docstring %{fzf [<dirs>]: open a file in the given directories
If no directories are given then the directory in which the current buffer was saved is used} \
    fzf %{ %sh{
    if [ -z "${TMUX}" ]; then
        printf 'echo -color Error This function must be run in a `tmux` session\n'
        exit
    fi

    if [ $# -ge 1 ]; then
        cwd=$(printf %s "$@" | sed 's/\//\\\//g')
    else
        cwd=$(dirname "${kak_buffile}" | sed 's/\//\\\//g')
    fi
    filesearch_cmd=$(printf %s "${kak_opt_fzf_filesearch_cmd}" | sed "s/%s/${cwd}/g")
    eval "${filesearch_cmd}" | eval "fzf-tmux ${kak_opt_fzf_options}" | while read path; do
        printf "eval -try-client '%s' edit '%s'" "${kak_client}" "${path}" \
            | kak -p "${kak_session}"
    done
} }

def -params .. -file-completion \
    -docstring %{fzf-cached [<dirs>] open a file in the given cached directories
If no directories are given then the directory in which the current buffer was saved is used} \
    fzf-cached %{
    %sh{
        if [ -z "${TMUX}" ]; then
            printf 'echo -color Error This function must be run in a `tmux` session\n'
            exit
        fi

        if [ $# -lt 0 ]; then
            printf %s\\n "find-parent-file %opt{fzf_cache_filename} global:fzf_cache_path 0 $@"
        else
            basedir=$(dirname "${kak_buffile}")
            printf %s\\n "find-parent-file %opt{fzf_cache_filename} global:fzf_cache_path 0 ${basedir}"
        fi
    }

    %sh{
        if [ -z "${kak_opt_fzf_cache_path}" ]; then
            exit
        fi
        paths_dir=$(dirname "${kak_opt_fzf_cache_path}")
        eval "fzf-tmux ${kak_opt_fzf_options}" < "${kak_opt_fzf_cache_path}" | while read path; do
            printf "eval -try-client '%s' edit '%s'" "${kak_client}" "${paths_dir}/${path}" \
                | kak -p "${kak_session}"
        done
    }
}
