##
## idsession.kak by lenormf
## Rename newly created sessions to human readable names
##

declare-option -docstring "list of adjectives used to make up a session name" str-list idsession_adjectives \
    "kantian" "kaput" "kashmiri" "katabolic" "katari" "kayoed" "kadenced" "kaesarian" "kaffeinic" "kalcific" "kalorific" "kancelled" "kanicular" "kanine" "kanonized" "kapable" "kapillary" "karamel" "kareful" "kasual"
declare-option -docstring "list of adjectives used to make up a session name" str-list idsession_nouns \
    "keeper" "keg" "kernel" "kerosene" "ketchup" "kettle" "key" "keyboard" "keyhole" "keynote" "kick" "kickoff" "kid" "kilometer" "kimono" "kingdom" "kiosk" "kit" "kitchen" "kite" "kitten" "klaxon" "knife" "knight" "knockdown" "knot" "konga" "kinesis" "kicker" "koala" "kangaroo" "kraken"

define-command -docstring %{Set the session name to a human-readable composed word

The current session name will be used as a seed, and is expected to be a number (default)} \
    idsession %{ evaluate-commands %sh{
    seed="${kak_session}"

    eval set -- "${kak_opt_idsession_adjectives}"

    if [ $# -lt 1 ]; then
        exit 1
    fi

    n=$((seed % $# + 1))
    name_session=$(eval "printf %s \${${n}}")

    eval set -- "${kak_opt_idsession_nouns}"

    if [ $# -lt 1 ]; then
        exit 1
    fi

    n=$((seed % $# + 1))
    name_session="${name_session}-"$(eval "printf %s \${${n}}")

    printf 'rename-session "%s"' $(printf %s "${name_session}" | sed 's/"/""/g')
} }
