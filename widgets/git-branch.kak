##
## git-branch.kak by lenormf
## Store the current git branch that contains the buffer
##

## current git branch
decl str modeline_git_branch

hook global WinCreate .* %{
    hook window NormalIdle .* %{ %sh{
        branch=$(cd $(readlink -e $(dirname ${kak_bufname})) && git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [ -n "${branch}" ]; then
            echo "set window modeline_git_branch '${branch}'"
        fi
    } }
}
