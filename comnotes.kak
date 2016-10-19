##
## comment_notes.kak by lenormf
## Highlight TODO, FIXME, NOTE and XXX comments
##

addhl -group / group comnotes

addhl -group /comnotes regex TODO|FIXME|XXX|NOTE 0:default+rb

# Assign the "comnotes" highlighter to each language's comments highlighter
## XXX: some scripts do not have a region dedicated to comments and just use
##      a regex to highlight them, thus keywords in those files can't be highlighted
%sh{
    LANGS="c:cabal:coffee:cpp:css:cucumber"
    LANGS="${LANGS}:d:dockerfile:fish:go:haml:haskell:html:ini"
    LANGS="${LANGS}:java:javascript:julia:kakrc:kickstart:latex:lisp:lua"
    LANGS="${LANGS}:makefile:moon:objc:perl:pug:python:ragel:ruby:rust:sass:scala:sh:swift"
    LANGS="${LANGS}:tupfile:yaml"
    for lang in $(printf %s\\n "${LANGS}" | tr : \\n); do
        echo "addhl -group /${lang}/comment ref comnotes"
    done
}
