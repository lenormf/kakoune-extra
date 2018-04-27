##
## vcs.kak by lenormf
## Auto-detect the path to the root of the current repository
##

declare-option -docstring "path to the root of the current project" str vcs_root_path

hook global BufCreate .* %{ %sh{
    for cmd in "git rev-parse --show-toplevel" \
               "svn info | awk '/Working Copy Root Path:/ { print substr($0, 25); }'" \
               "hg root" \
               "bzr root"
    do
        path=$(eval "${cmd}" 2>/dev/null)
        if [ -n "${path}" ]; then
            printf 'set-option buffer vcs_root_path %%{%s}\n' "${path}"
            break
        fi
    done
} }
