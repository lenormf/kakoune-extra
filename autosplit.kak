##
## autosplit.kak by lenormf
## Split the view according to a predefined layout
##

def autosplit -params ..2 -docstring %{
autosplit [<layout> [<size>]]: split the current view according to the terminal size
Available layouts:
  - vstack: vertical stack with a left hand side main view
  - hstack: horizontal stack with a top main view
  - grid: array of equally sized tiles

Available sizes:
  - large
  - medium
  - small

The default layout is `vstack`, and the size is autodetected if unspecified
    } %{ %sh{
    readonly WIDTH_BASE=70
    readonly HEIGHT_BASE=20

    fatal() {
        printf 'echo -color Error %s' "$*"
        exit 1
    }

    layout="${1:-vstack}"
    case "${layout}" in
        vstack|hstack|grid);;
        *) fatal "Invalid layout name: ${layout}";;
    esac

    if [ $# -lt 2 ]; then
        if [ "${kak_window_width}" -ge $((WIDTH_BASE * 2)) ] && [ "${kak_window_height}" -ge $((HEIGHT_BASE * 3)) ]; then
            size=large
        elif [ "${kak_window_width}" -ge "${WIDTH_BASE}" ] && [ "${kak_window_height}" -ge $((HEIGHT_BASE)) ]; then
            size=medium
        else
            size=small
        fi
    else
        size="${2}"
    fi

    case "${size}" in
        small|medium|large);;
        *) fatal "Invalid size name: ${size}";;
    esac

    multiplexer="none"
    if [ -n "${DVTM_CMD_FIFO}" ]; then
        multiplexer="dvtm"
    elif [ -n "${TMUX}" ]; then
        multiplexer="tmux"
    fi

    case "${multiplexer}" in
        dvtm|tmux);;
        *) fatal "Unsupported multiplexer: ${multiplexer}"
    esac

    setup_multiplexer_dvtm() {
        layout="${1}"
        size="${2}"

        setup_size_large() {
            layout="${1}"

            case "${layout}" in
                vstack)
                    echo "
                        rename-client '%opt{toolsclient}'
                        dvtm-new-window 'rename-client \"%opt{jumpclient}\"'
                        dvtm-new-window 'rename-client \"%opt{docsclient}\"'
                        dvtm-new-window
                    "
                ;;
                hstack|grid) fatal "unimplemented";;
            esac
        }

        setup_size_medium() {
            layout="${1}"

            case "${layout}" in
                vstack)
                    echo "
                        rename-client \"%opt{jumpclient}\"
                        dvtm-new-window 'rename-client \"%opt{docsclient}\"'
                        dvtm-new-window
                    "
                ;;
                hstack|grid) fatal "unimplemented";;
            esac
        }

        setup_size_small() {
            layout="${1}"

            case "${layout}" in
                vstack)
                    echo "
                        rename-client \"%opt{docsclient}\"
                        dvtm-new-window
                    "
                ;;
                hstack|grid) fatal "unimplemented";;
            esac
        }

        eval "setup_size_${size} '${layout}'"
    }

    setup_multiplexer_tmux() {
        layout="${1}"
        size="${2}"

        setup_size_large() {
            layout="${1}"

            case "${layout}" in
                vstack)
                    printf '
                        tmux-new-horizontal rename-client "%%opt{docsclient}"
                        tmux-new-vertical rename-client "%%opt{jumpclient}"
                        tmux-new-vertical rename-client "%%opt{toolsclient}"
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout main-vertical \; resize-pane -x %d
                        }
                    ' "${kak_client}" "${TMUX}" $((kak_window_width / 2))
                ;;
                hstack)
                    printf '
                        tmux-new-vertical rename-client "%%opt{docsclient}"
                        tmux-new-horizontal rename-client "%%opt{jumpclient}"
                        tmux-new-horizontal rename-client "%%opt{toolsclient}"
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout main-horizontal \; resize-pane -y %d
                        }
                    ' "${kak_client}" "${TMUX}" $((kak_window_height / 2))
                ;;
                grid)
                    printf '
                        tmux-new-horizontal rename-client "%%opt{docsclient}"
                        tmux-new-horizontal rename-client "%%opt{jumpclient}"
                        tmux-new-horizontal rename-client "%%opt{toolsclient}"
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout tiled
                        }
                    ' "${kak_client}" "${TMUX}"
                ;;
            esac
        }

        setup_size_medium() {
            layout="${1}"

            case "${layout}" in
                vstack)
                    printf '
                        tmux-new-horizontal rename-client "%%opt{docsclient}"
                        tmux-new-vertical rename-client "%%opt{jumpclient}"
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout main-vertical \; resize-pane -x %d
                        }
                    ' "${kak_client}" "${TMUX}" $((kak_window_width / 2))
                ;;
                hstack)
                    printf '
                        tmux-new-vertical rename-client "%%opt{docsclient}"
                        tmux-new-horizontal rename-client "%%opt{jumpclient}"
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout main-horizontal \; resize-pane -y %d
                        }
                    ' "${kak_client}" "${TMUX}" $((kak_window_height / 2))
                ;;
                grid)
                    printf '
                        rename-client "%%opt{docsclient}"
                        tmux-new-vertical rename-client "%%opt{jumpclient}"
                        tmux-new-vertical
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout tiled
                        }
                    ' "${kak_client}" "${TMUX}"
                ;;
            esac
        }

        setup_size_small() {
            layout="${1}"

            case "${layout}" in
                vstack)
                    printf '
                        tmux-new-horizontal rename-client "%%opt{docsclient}"
                        try %%{ focus "%s" }
                    ' "${kak_client}"
                ;;
                hstack)
                    printf '
                        tmux-new-vertical rename-client "%%opt{docsclient}"
                        try %%{ focus "%s" }
                    ' "${kak_client}"
                ;;
                grid)
                    printf '
                        rename-client "%%opt{docsclient}"
                        tmux-new-vertical
                        try %%{ focus "%s" }
                        nop %%sh{
                            env TMUX="%s" tmux select-layout tiled
                        }
                    ' "${kak_client}" "${TMUX}"
                ;;
            esac
        }

        eval "setup_size_${size} '${layout}'"
    }

    eval "setup_multiplexer_${multiplexer} '${layout}' '${size}'"
} }
