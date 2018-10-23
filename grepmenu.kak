##
## grepmenu.kak for kakoune-extra
## by lenormf
##

declare-option -docstring "shell command run to look for a pattern" str grepmenucmd "ag --all-text --vimgrep"

define-command -params 1.. -file-completion \
    -docstring %{grepmenu <pattern> [targets]: search one or more targets for a given pattern} \
    grepmenu %{ evaluate-commands %sh{
        readonly PATTERN="$1"

        shift

        eval "${kak_opt_grepmenucmd}" "${PATTERN}" -- "$@" | awk "
            /^[^:]*:[0-9]*:[0-9]*:/ {
                # escape all simple quotes
                gsub(/'/, \"''\")
                # gather filename and coordinates into an array
                split(\$0, s, \":\")

                # remove the coordinates information from the matched line
                sub(\"^[^:]*:[0-9]*:[0-9]*:\", \"\")

                # strip the matched line
                sub(\"^[ \t]*|[ \t]*\$\", \"\")

                candidates = candidates \" \" \"'\" s[1] \":\" s[2] \":\" s[3] \" \" \$0 \"' ' edit! %{\" s[1] \"} \" s[2] \" \" s[3] \"'\"
            }

            END {
                if (length(candidates))
                    print \"menu\" candidates
            }
        "
} }
