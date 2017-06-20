##
## overstrike.kak by lenormf
## Overstrike markup parser
##

decl -hidden range-specs overstrike_ranges

face OverstrikeBold default+b
face OverstrikeUnderline default+u

%sh{
    # https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
    ansi_index_to_color() {
        case "${1}" in
            0) echo "black";;
            1) echo "red";;
            2) echo "green";;
            3) echo "yellow";;
            4) echo "blue";;
            5) echo "magenta";;
            6) echo "cyan";;
            7) echo "white";;
            *) echo "default";;
        esac
    }

    ansi_to_face() {
        capacity="$1"
        color_fg='default'
        color_bg='default'
        attributes='e'

        descriptors=$(expr "${capacity}" : '^.\[\([0-9]*\(;[0-9]*\)*\)m$')
        if [ $? -eq 0 ]; then
            # TODO: support bright colors, whenever kakoune supports them as well
            for code in $(printf %s "${descriptors}" | tr ';' '\n' | sed 's/ +//g'); do
                code=$((code))

                case "${code}" in
                    1) attributes="${attributes}b";;
                    3) attributes="${attributes}i";;
                    4) attributes="${attributes}u";;
                    5) attributes="${attributes}B";;
                    7) attributes="${attributes}r";;
                    30|31|32|33|34|35|36|37) color_fg=$(ansi_index_to_color $((code - 30)));;
                    40|41|42|43|44|45|46|47) color_bg=$(ansi_index_to_color $((code - 40)));;
                    *) printf 'Unsupported code: %s\n' "${code}" >&2;;
                esac
            done
        else
            printf 'Unsupported capacity format: %s\n' "${capacity}" >&2
            exit 1
        fi

        printf %s\\n "${color_fg},${color_bg}+${attributes}"
    }

    if [ -n "${LESS_TERMCAP_md}" ] && [ -n "${LESS_TERMCAP_us}" ]; then
        face_bold=$(ansi_to_face "${LESS_TERMCAP_md}")
        face_underline=$(ansi_to_face "${LESS_TERMCAP_us}")

        if [ -n "${face_bold}" ]; then
            printf 'face OverstrikeBold "%s"\n' "${face_bold}"
        fi
        if [ -n "${face_underline}" ]; then
            printf 'face OverstrikeUnderline "%s"\n' "${face_underline}"
        fi
    fi
}

def -hidden overstrike-parse-bold %{
    eval -draft %{
        try %{
            exec '%1s(.\x08).<ret>d<a-m>'
            update-option window overstrike_ranges

            eval -itersel %{
                set -add window overstrike_ranges "%val{selection_desc}|OverstrikeBold"
            }
        }
    }
}

def overstrike-parse -docstring "Parse the contents of the current buffer and convert the overstrike escapes to ranges" %{
    set window overstrike_ranges "%val{timestamp}"

    eval -draft %{
        try %{
            exec '%1s(_\x08).<ret>d<a-m>'
            update-option window overstrike_ranges

            overstrike-parse-bold

            eval -itersel %{
                set -add window overstrike_ranges "%val{selection_desc}|OverstrikeUnderline"
            }
        } catch %{
            overstrike-parse-bold
        }
    }

    addhl ranges overstrike_ranges
}
