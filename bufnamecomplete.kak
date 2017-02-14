##
## bufnamecomplete.kak by lenormf
## Print a menu to edit files whose name start with the current buffer name
## Mostly useful when the shell only completes the common prefix of several
## files in the current working directory
## e.g. `kak abc<tab><ret>`, in a directory with the following files:
##      abcdef.log abc.txt
##

hook global WinDisplay [^*].* %{ %sh{
    if [ ! -e "${kak_buffile}" ]; then
        readonly dir_buffer=$(dirname "${kak_buffile}")
        if [ ! -d "${dir_buffer}" ]; then
            exit
        fi

        readonly command_menu=$(find "${dir_buffer}" -maxdepth 1 -type f -name "${kak_buffile##*/}*" \
                                    -exec printf '"%s" "edit %%{%s}"' "$(basename '{}')" '{}' \;)

        if [ -n "${command_menu}" ]; then
            printf 'eval %%{%s}\n' "menu ${command_menu}"
        fi
    fi
} }
