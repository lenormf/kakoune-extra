##
## selectsave.kak by lenormf
## Save the selection when writing a buffer, and restore them when opening it later
##

decl -docstring "path to the directory in which the cache is stored" \
    str selectsave_path_dir_cache %sh{printf %s "${XDG_CONFIG_HOME:-${HOME}/.config}/kak"}
decl -docstring "full path to the cache file" str selectsave_path_cache "%opt{selectsave_path_dir_cache}/selections_desc.txt"

hook global WinDisplay [^*].* %{ %sh{
    if [ -e "${kak_opt_selectsave_path_cache}" ]; then
        readonly PATTERN_SELECTIONS='[0-9]+\.[0-9]+,[0-9]+\.[0-9]+(:[0-9]+\.[0-9]+,[0-9]+\.[0-9]+)*'
        readonly PATTERN_CURBUF="^${kak_buffile} ${PATTERN_SELECTIONS}\$"

        info_curbuf=$(grep -E "${PATTERN_CURBUF}" "${kak_opt_selectsave_path_cache}")
        selection_desc=$(expr "${info_curbuf}" : "${kak_buffile} \\(.*\\)\$")
        if [ -n "${info_curbuf}" ] && [ -n "${selection_desc}" ]; then
            readonly PATH_TMP=$(mktemp)

            printf 'eval -client %%{%s} select "%s"\n' "${kak_client}" "${selection_desc}" | kak -p "${kak_session}"

            grep -v -E "${PATTERN_CURBUF}" "${kak_opt_selectsave_path_cache}" > "${PATH_TMP}"
            mv "${PATH_TMP}" "${kak_opt_selectsave_path_cache}"
        fi
    fi
} }

hook global BufWritePost [^*].* %{ %sh{
    if [ -e "${kak_buffile}" ]; then
        {
            mkdir -p "${kak_opt_selectsave_path_dir_cache}";
            touch "${kak_opt_selectsave_path_cache}";
        } || exit

        readonly PATTERN_SELECTIONS='[0-9]+\.[0-9]+,[0-9]+\.[0-9]+(:[0-9]+\.[0-9]+,[0-9]+\.[0-9]+)*'
        readonly PATTERN_CURBUF="^${kak_buffile} ${PATTERN_SELECTIONS}\$"
        if grep -q -E "${PATTERN_CURBUF}" "${kak_opt_selectsave_path_cache}"; then
            readonly PATH_TMP=$(mktemp)

            grep -v -E "${PATTERN_CURBUF}" "${kak_opt_selectsave_path_cache}" > "${PATH_TMP}"
            mv "${PATH_TMP}" "${kak_opt_selectsave_path_cache}"
        fi

        printf '%s %s\n' "${kak_buffile}" "${kak_selections_desc}" >> "${kak_opt_selectsave_path_cache}"
    fi
} }
