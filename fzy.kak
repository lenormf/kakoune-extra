##
## fzy.kak by lenormf
## Support function for the `fzy` utility
## https://github.com/jhawthorn/fzy
##

# `fzy-cached` requires `find-parent-file` in `utils.kak`

decl str fzy_filesearch_cmd 'ag -g "" "%s"'
decl str fzy_options '-l $(tput lines)'
decl str fzy_cache_filename 'paths'

decl -hidden str fzy_cache_path

def -params .. -file-completion \
    -docstring %{fzy [<dirs>]: open a file in the given directories
If no directories are given then the directory in which the current buffer was saved is used} \
    fzy %{ %sh{
    cmd_multiplexer=""
    if [ -n "${DVTM_CMD_FIFO}" ]; then
        cmd_multiplexer="fzy-dvtm"
    elif [ -n "${TMUX}" ]; then
        cmd_multiplexer="fzy-tmux"
    else
        printf 'echo -color Error This function must be run in a `dvtm` or `tmux` session\n'
        exit 1
    fi

    if [ $# -ge 1 ]; then
        cwd=$(printf %s "$*" | sed 's/\//\\\//g')
    else
        cwd=$(dirname "${kak_buffile}" | sed 's/\//\\\//g')
    fi
    filesearch_cmd=$(printf %s "${kak_opt_fzy_filesearch_cmd}" | sed "s/%s/${cwd}/g")
    eval "${filesearch_cmd}" | eval "'${cmd_multiplexer}' ${kak_opt_fzy_options}" | while read path; do
        printf "eval -try-client '%s' edit '%s'" "${kak_client}" "${path}" \
            | kak -p "${kak_session}"
    done
} }

def -params .. -file-completion \
    -docstring %{fzy-cached [<dirs>] open a file in the given cached directories
If no directories are given then the directory in which the current buffer was saved is used} \
    fzy-cached %{
    %sh{
        if [ -z "${DVTM_CMD_FIFO}" ] && [ -z "${TMUX}" ]; then
            printf 'echo -color Error This function must be run in a `dvtm` or `tmux` session\n'
            exit 1
        fi

        if [ $# -lt 0 ]; then
            printf %s\\n "find-parent-file %opt{fzy_cache_filename} global:fzy_cache_path 0 $@"
        else
            basedir=$(dirname "${kak_buffile}")
            printf %s\\n "find-parent-file %opt{fzy_cache_filename} global:fzy_cache_path 0 ${basedir}"
        fi
    }

    %sh{
        if [ -z "${kak_opt_fzy_cache_path}" ]; then
            exit
        fi
        cmd_multiplexer=""
        if [ -n "${DVTM_CMD_FIFO}" ]; then
            cmd_multiplexer="fzy-dvtm"
        elif [ -n "${TMUX}" ]; then
            cmd_multiplexer="fzy-tmux"
        fi

        paths_dir=$(dirname "${kak_opt_fzy_cache_path}")
        eval "'${cmd_multiplexer}' ${kak_opt_fzy_options}" < "${kak_opt_fzy_cache_path}" | while read path; do
            printf "eval -try-client '%s' edit '%s'" "${kak_client}" "${paths_dir}/${path}" \
                | kak -p "${kak_session}"
        done
    }
}
