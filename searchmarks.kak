##
## searchmarks.kak for kakoune-extra
## by lenormf
##

declare-option -hidden line-specs searchmarks_flags

set-face global SearchMark LineNumbers

define-command -hidden -params 2 searchmarks-impl %{
    try %{
        execute-keys -save-regs '' %arg{1} %arg{2} <ret>

        evaluate-commands -draft %{
            execute-keys \%s <ret>

            evaluate-commands %sh{
                printf %s "${kak_selections_desc}" | awk -v timestamp="${kak_timestamp}" '
                    {
                        for (i = 1; i <= NF; i++) {
                            split($i, n, /,|\./)
                            line_begin = n[1]
                            line_end = n[3]

                            for (j = line_begin; j <= line_end; j++)
                                lines[j]++
                        }
                    }
                    END{
                        specs = ""
                        for (i in lines)
                            specs = specs " " i "|{SearchMark}" lines[i]

                        if (length(specs))
                            printf "set-option window searchmarks_flags %d%s", timestamp, specs
                    }
                '
            }
        }

        try %{ add-highlighter window/searchmarks flag-lines Default searchmarks_flags }
    } catch %{
        remove-highlighter window/searchmarks
    }
}

define-command -params 1 -docstring %{
    search-marks <primitive>: Hint at search matches with markers and match counts

The primitive argument is whatever key spawns a prompt, and search for a given pattern (e.g. `/`)
    } search-marks %{
        prompt -init %reg{/} "search (%arg{1}):" "searchmarks-impl %arg{1} %%val{text}"
}
