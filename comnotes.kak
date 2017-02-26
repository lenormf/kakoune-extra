##
## comnotes.kak by lenormf
## Highlight TODO, FIXME, NOTE and XXX comments
##

hook global WinSetOption filetype=.+ %{
    try %{ addhl regex \<(TODO|FIXME|XXX|NOTE)\> 0:default+rb }
}
