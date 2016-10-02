##
## dvtm.kak by lenormf
## Support for client creation/tagging/focusing from a kakoune client
##

# http://www.brain-dump.org/projects/dvtm/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global KakBegin .* %{
    %sh{
        if [ -n "${DVTM}" ]; then
            echo "
                alias global new dvtm-new-window
                alias global focus dvtm-focus
            "
        fi
    }
}

def -params .. -command-completion -docstring "Create a new window in dvtm" \
    dvtm-new-window %{ %sh{
    params=""
    if [ $# -gt 0 ]; then
        ## `dvtm` requires those simple quotes to be escaped even within double quotes
        params="-e \\'$@\\'"
    fi

    ## The FIFO command pipe has to be created using the `-c` flag
    if [ -p "${DVTM_CMD_FIFO}" ]; then
        printf %s\\n "create \"kak -c ${kak_session} ${params}\"" > "${DVTM_CMD_FIFO}"
    else
        printf %s\\n 'echo -color Error No command socket available'
    fi
} }

def -params 0..1 -client-completion -docstring "Focus a client in dvtm" \
    dvtm-focus %{ %sh{
    if [ $# -eq 1 ]; then
        printf %s\\n "eval -client '$1' focus"
    elif [ -p "${DVTM_CMD_FIFO}" ]; then
        printf %s\\n "focus ${kak_client_env_DVTM_WINDOW_ID}" > "${DVTM_CMD_FIFO}"
    fi
} }

def -params 1..2 -client-completion -docstring "Tag a client in dvtm" \
    dvtm-tag %{ %sh{
    isnum() {
        expr "$@" : '^[0-9]*$' 2>&1 >/dev/null
    }

    if [ $# -eq 2 ]; then
        if isnum "$2"; then
            printf %s\\n "eval -client '$1' dvtm-tag $2"
        else
            printf %s\\n 'echo -color Error Second argument is not a number'
        fi
    elif [ $# -eq 1 ]; then
        if [ -p "${DVTM_CMD_FIFO}" ]; then
            if isnum "$1"; then
                printf %s\\n "tag ${kak_client_env_DVTM_WINDOW_ID} $1" > "${DVTM_CMD_FIFO}"
            else
                printf %s\\n 'echo -color Error Second argument is not a number'
            fi
        fi
    else
        printf %s\\n "echo -color Error Not enough arguments"
    fi
} }
