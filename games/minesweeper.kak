# kakoune implementation of the minesweeper game

def -params 3 -docstring %{minesweeper <lines> <columns> <mines>: play a game of minesweeper in a grid of size <lines>x<columns> containing <mines> mines
press <space> to uncover a square
press f to flag it} \
minesweeper %{
    minesweeper_quit
    edit -scratch *minesweeper_solution*
    # create $1*$2 lines made of ' \n'
    exec %sh{ printf %d $(($1 * $2)) }o<space><esc>gkd
    # replace the first $3 with 'x\n'
    exec  %arg{3} Crx
    # shuffle them, POSIX-compliant style (;_;)
    exec %{ %|awk 'BEGIN {srand(); OFMT="%.17f"} {print rand(), $0}' "$@"<ret>|sort -k1,1n<ret>|cut -d ' ' -f2-<ret>}
    # join them in a $1x$2 grid
    exec \%s(.\n){ %arg{2} }<ret>K<a-s>ld
    # surround them by #
    exec '%<a-s>i#<esc>a#<esc><space>xypxHr#LygkP'

    eval %{
        # copy that layout to the play buffer
        exec -save-regs '' '%y'
        edit -scratch *minesweeper*
        # but remove all 'x' here
        exec -draft 'pd%sx<ret>r<space>'
        exec jl
    }

    add-highlighter shared group minesweeper
    add-highlighter shared/minesweeper regex '\d' 0:black,green
    add-highlighter shared/minesweeper regex 'x' 0:black,red
    add-highlighter shared/minesweeper regex '!' 0:black,yellow
    map buffer normal <space> ':minesweeper_check<ret>'
    map buffer normal f ':minesweeper_toggle_flag<ret>'
}

def -hidden minesweeper_quit %{
    try %{ remove-highlighter shared/minesweeper       }
    try %{ delete-buffer *minesweeper_solution* }
    try %{ delete-buffer *minesweeper*          }
}

def -hidden minesweeper_toggle_flag %{
    try %{
        exec 's<space><ret>r!'
    } catch %{
        try %{
            exec 's!<ret>r<space>'
        }
    }
}

decl -hidden str minesweeper_save_position

# this command is meant to be called only on a blank squre
def -hidden minesweeper_uncover_current %{
    set global minesweeper_save_position %val{selection_desc}
    # go to the solution buffer at the same position
    buffer *minesweeper_solution*
    select %opt{minesweeper_save_position}
    # after this block, register " will contain what we uncover
    try %{
        exec <a-k>x<ret>
        # we're on a mine
        reg '"' x
    } catch %{
        # not on a mine
        # expand in a circle around the current position
        exec hkCCLL
        try %{
            # select mines
            exec sx<ret>
            # count them
            reg '"' %reg{#}
        } catch %{
            # no mines -> 0
            reg '"' 0
        }
    }
    # go back to the minesweeper buffer
    buffer *minesweeper*
    select %opt{minesweeper_save_position}
    # and replace the checked position with what we found
    exec R
}

def -hidden minesweeper_check_won %{
    exec '%s[ !]<ret>'
    set global minesweeper_save_position %val{selections_desc}
    buffer *minesweeper_solution*
    select %opt{minesweeper_save_position}
    exec '<a-k> <ret>'
}

def -hidden minesweeper_check_recursive %{
    try %{
        # find all safe squares
        exec '%s0<ret>'
        # that are surrounded by at least one covered square
        exec 'hkCCLLs <ret>'
        # and uncover them independently
        eval -itersel minesweeper_uncover_current
        # recursively because we may have uncovered other 0
        minesweeper_check_recursive
    }
}

def -hidden minesweeper_check %{
    try %{
        # ensure we're trying to check a space
        exec '<space>;<a-k> <ret>'
        eval minesweeper_uncover_current
        # check surroundings if we just uncovered a 0
        try %{
            exec <a-k>0<ret>
            eval -draft minesweeper_check_recursive
        }
        # check winning/losing condition
        try %{
            exec <a-k>x<ret>
            info 'You lost, better luck next time.'
        } catch %{ 
            try %{
                eval -draft minesweeper_check_won
            } catch %{
                info 'You won, congratulations!'
            }
        }
    }
}

