##
## hatch_terminal.kak by lenormf
## Spawn a new shell/command whose environment contains Kakoune metadata
##

def hatch-terminal-x11 -params .. -docstring %{
hatch-terminal-x11 [command]: open a new X11 terminal
If specified, the command will be ran in the newly created terminal, otherwise a shell is spawned
The environment contains the `KAK_SESSION` variable set to the parent session's name
} %{ %sh{
    setsid ${kak_opt_termcmd} "env TMPDIR='${TMPDIR}' \
        KAK_SESSION='${kak_session}' \
        KAK_CLIENT='${kak_client}' \
        ${*:-${SHELL}}" </dev/null >/dev/null 2>&1 &
} }

def hatch-terminal-tmux -params .. -docstring %{
hatch-terminal-tmux [command]: open a new `tmux` horizontal pane
If specified, the command will be ran in the newly created terminal, otherwise a shell is spawned
The environment contains the `KAK_SESSION` variable set to the parent session's name
} %{ %sh{
    env TMUX="${kak_client_env_TMUX:-${TMUX}}" tmux split-window -h \
        "env TMPDIR='${TMPDIR}' \
            KAK_SESSION='${kak_session}' \
            KAK_CLIENT='${kak_client}' \
            ${*:-${SHELL}}" </dev/null >/dev/null 2>&1 &
} }

def hatch-terminal-dvtm -params .. -docstring %{
hatch-terminal-dvtm [command]: open a new `dvtm` pane
If specified, the command will be ran in the newly created terminal, otherwise a shell is spawned
The environment contains the `KAK_SESSION` variable set to the parent session's name
} %{ %sh{
    if [ -p "${DVTM_CMD_FIFO}" ]; then
        printf %s\\n "create \"env TMPDIR='${TMPDIR}' \
            KAK_SESSION='${kak_session}' \
            KAK_CLIENT='${kak_client}' \
            ${*:-${SHELL}}\"" > "${DVTM_CMD_FIFO}"
    fi
} }

%sh{
    if [ -n "${TMUX}" ]; then
        echo "alias global hatch-terminal hatch-terminal-tmux"
    elif [ -n "${DVTM}" ]; then
        echo "alias global hatch-terminal hatch-terminal-dvtm"
    elif [ -n "${DISPLAY}" ]; then
        echo "alias global hatch-terminal hatch-terminal-x11"
    fi
}
