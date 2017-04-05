##
## idsession.kak by lenormf
## Rename newly created sessions to human readable names
##

hook global KakBegin .* %{ %sh{
    readonly ADJECTIVES="kantian:kaput:kashmiri:katabolic:katari:kayoed:kadenced:kaesarian:kaffeinic:kalcific:kalorific:kancelled:kanicular:kanine:kanonized:kapable:kapillary:karamel:kareful:kasual"
    readonly NAMES="keeper:keg:kernel:kerosene:ketchup:kettle:key:keyboard:keyhole:keynote:kick:kickoff:kid:kilometer:kimono:kingdom:kiosk:kit:kitchen:kite:kitten:klaxon:knife:knight:knockdown:knot:konga:kinesis:kicker:koala:kangaroo:kraken"

    rnd() {
        seed=$(($$ * $(date +%s)))
        echo | awk "{srand(${seed}); n=rand(); sub(/0\\./, //, n); print n;}"
    }

    select_list_idx() {
        idx=$(($1 + 1))
        shift

        eval "printf %s \${${idx}}"
    }

    nb_adj=$(printf %s "${ADJECTIVES}" | tr ':' '\n' | wc -l)
    nb_names=$(printf %s "${NAMES}" | tr ':' '\n' | wc -l)

    idx_adj=$(($(rnd) % nb_adj))
    idx_name=$(($(rnd) % nb_names))

    adj=$(select_list_idx ${idx_adj} $(printf %s "${ADJECTIVES}" | tr ':' ' '))
    name=$(select_list_idx ${idx_name} $(printf %s "${NAMES}" | tr ':' ' '))

    printf 'rename-session %s-%s' "${adj}" "${name}"
} }
