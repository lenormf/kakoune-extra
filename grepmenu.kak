declare-option str grepmenucmd "ag --all-text --vimgrep"

define-command -params 1.. -file-completion \
    -docstring %{grepmenu <pattern> [targets]: search one or more targets for a given pattern} \
    grepmenu %{ %sh{
        readonly PATTERN="$1"

        shift

        eval "${kak_opt_grepmenucmd}" "${PATTERN}" "$@" | awk -v nb_lines=0 -v QUOTE="'" \
            '/^[^:]*:[0-9]*:[0-9]*:/ {
                split($0, s, ":")

                # remove the coordinates information from the line
                sub("^[^:]*:[0-9]*:[0-9]*:", "")
                # escape all backslash
                gsub("\\\\", "\\\\")
                # escape all single quotes
                gsub(QUOTE, "\\" QUOTE)
                # strip the line
                sub("^[ \t]*|[ \t]*$", "")

                if (length() > ENVIRON["kak_window_width"])
                    sub(".{" (ENVIRON["kak_window_width"] - length()) "}$", "")

                if (!nb_lines)
                    printf "menu"

                # NOTE: we display a trailing space after the matched line to workaround issue #1049
                printf " %c%s:%d:%d %s %c %%{ edit! %%{%s} %d %d}", QUOTE, s[1], s[2], s[3], $0, QUOTE, s[1], s[2], s[3]
                nb_lines++
            }'
} }
