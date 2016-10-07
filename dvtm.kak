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
    else
        printf %s\\n "echo -color Error No command socket available"
    fi
} }

def -params 1.. -docstring "Tag the current client in dvtm" \
    dvtm-tag-current %{ %sh{
    if [ -p "${DVTM_CMD_FIFO}" ]; then
        printf %s\\n "tag ${kak_client_env_DVTM_WINDOW_ID} $*" > "${DVTM_CMD_FIFO}"
    else
        printf %s\\n "echo -color Error No command socket available"
    fi
} }

def -params 2.. -client-completion -docstring "Tag a client in dvtm" \
    dvtm-tag %{ %sh{
    if [ -p "${DVTM_CMD_FIFO}" ]; then
        readonly client_name="$1"; shift
        printf %s\\n "eval -client '${client_name}' dvtm-tag-current $*"
    else
        printf %s\\n "echo -color Error No command socket available"
    fi
} }

def -params 1.. -docstring "Interact with dvtm using the dvtm-cmd utility" \
    dvtm-cmd %{ %sh{
    if [ -p "${DVTM_CMD_FIFO}" ]; then
        readonly command="$1"; shift
        readonly output=$(dvtm-cmd "${command}" "$@" 2>&1)

        if [ -n "${output}" ]; then
            printf %s\\n "echo -color Error %{ ${output} }"
        fi
    else
        printf %s\\n "echo -color Error No command socket available"
    fi
} }
