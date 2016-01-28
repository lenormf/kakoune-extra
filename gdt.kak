##
## gdt.kak by lenormf
## Highlight TODO, FIXME and XXX comments
##

# Create a subgroup called "gdt"
addhl -group / group gdt

# Make the subgroup highlight certain keywords
addhl -group /gdt regex TODO|FIXME|XXX 0:default+rb

# Assign the "gdt" highlighter to each language's comments highlighter
%sh{
    LANGS=(
        cabal
        coffee
        cpp
        css
        cucumber
        dlang
        fish
        golang
        haml
        haskell
        html
        java
        javascript
        julia
        kakrc
        kickstart
        lisp
        objc
        python
        ragel
        ruby
        rust
        sass
        scala
        sh
        yaml
    )
    for lang in "${LANGS[@]}"; do
        echo "addhl -group /${lang}/comment ref gdt"
    done
}
