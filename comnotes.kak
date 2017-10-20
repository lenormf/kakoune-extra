##
## comnotes.kak by lenormf
## Highlight TODO, FIXME, NOTE and XXX comments
##

hook global WinSetOption filetype=.+ %{
    try %{ addhl regex \b(TODO|FIXME|XXX|NOTE)\b 0:default+rb }
}
