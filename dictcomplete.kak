##
## dictcomplete.kak by lenormf
## Dictionary completion based on `aspell` in text-based buffers
##

declare-option -docstring "minimum amount of characters in a word necessary to trigger completion" int dict_min_chars 3
declare-option -docstring "language identifier passed to `aspell` when loading a dictionary" str dict_lang "en"
declare-option -docstring %{
    size of the dictionary to load, as per `aspell` conventions:
      - 10: tiny
      - 20: really small
      - 30: small
      - 40: med-small
      - 50: med
      - 60: med-large
      - 70: large
      - 80: huge
      - 90: insane
    } \
    int dict_size 30

declare-option -hidden completions dict_completions

define-command -hidden -params 1 dict-complete %{ evaluate-commands %sh{
    {
        candidates=$(
            printf %s "${1}" | aspell -a \
                                      -l "${kak_opt_dict_lang:-en}" \
                                      --size "${kak_opt_dict_size:-30}" \
                | awk -F ", " \
                      -v y="${kak_cursor_line}" \
                      -v x="${kak_cursor_column}" \
                      -v ts="${kak_timestamp}" '
                    BEGIN {
                        prefix = y "." x "@" ts
                        candidates = ""
                    }
                    END {
                        if (length(candidates))
                            print prefix candidates
                    }
                    /^&/ {
                        sub(/^&[^:]+: /, "", $0)

                        for (i = 1; i <= NF; i++) {
                            gsub(/\|/, "\\|", $i)
                            gsub("~", "~~", $i)
                            candidates = candidates " %~" $i "||{value}" $i "~"
                        }
                    }
                ')

        if [ -n "${candidates}" ]; then
            printf 'set %%{buffer=%s} dict_completions %s' "${kak_buffile}" "${candidates}" | kak -p "${kak_session}"
        fi
    } >/dev/null 2>&1 </dev/null &
} }

define-command -docstring %{Enable dictionary-completion for the current buffer} \
    dict-complete-enable %{
    set-option window completers option=dict_completions %opt{completers}

    hook -group dict-complete buffer InsertIdle .* %{
        try %{
            evaluate-commands -draft %{
                execute-keys h<a-i><a-w> <a-\;> "<a-k>[^\n]{%opt{dict_min_chars},}<ret>"
                dict-complete %val{selection}
            }
        } catch %{
            set-option buffer dict_completions
        }
    }
}
