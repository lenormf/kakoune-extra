##
## dictcomplete.kak by lenormf
## Dictionary completion based on `aspell` in text-based buffers
##

decl -docstring "minimum amount of characters in a word necessary to trigger completion" int dict_min_chars 3
decl -docstring "language identifier passed to `aspell` when loading a dictionary" str dict_lang "en"
decl -docstring %{size of the dictionary to load, as per `aspell` conventions:
  - 10: tiny
  - 20: really small
  - 30: small
  - 40: med-small
  - 50: med
  - 60: med-large
  - 70: large
  - 80: huge
  - 90: insane} \
    int dict_size 30

decl -hidden completions dict_completions

def -hidden -params 1 dict-complete %{
    set buffer dict_completions %sh{
        export kak_coord_word_x=$((kak_cursor_column - ${#1}))

        printf %s\\n "${1}" | aspell -a -l "${kak_opt_dict_lang:-en}" --size "${kak_opt_dict_size:-30}" \
            | awk '
            /^&/ {
                FS=", "
                sub(/^&[^:]+: /, "", $0)
                prefix = ENVIRON["kak_cursor_line"] "." ENVIRON["kak_coord_word_x"] "@" ENVIRON["kak_timestamp"]

                if (NF < 1) exit
                printf "%s", prefix
                for (i = 1; i <= NF; i++)
                    printf ":%s||{value}%s", $i, $i
            }
        '
    }
}

hook global WinSetOption filetype=(plain|asciidoc|markdown|git-commit) %{
    set window completers "option=dict_completions:%opt{completers}"
    hook -group dictcomplete buffer InsertIdle .* %{
        try %{
            eval -save-regs m %{
                exec -draft h<a-i>W "<a-k>[^\n]{%opt{dict_min_chars},}<ret>" \"my
                dict-complete %reg{m}
            }
        } catch %{
            set buffer dict_completions ''
        }
    }
}
