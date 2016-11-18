##
## comment_notes.kak by lenormf
## Highlight TODO, FIXME, NOTE and XXX comments
##

hook global WinSetOption filetype=.+ %{
    addhl regex TODO|FIXME|XXX|NOTE 0:default+rb
}
