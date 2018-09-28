##
## versioncheck.kak for kakoune-extra
## by lenormf
##

hook global KakBegin .* %{ evaluate-commands %sh{
    upstream_version=$(curl -si 'https://github.com/mawww/kakoune/releases/latest' \
                        | awk -F/ '/^Location:/{ print $NF; }' \
                        | sed 's/.$//')
    version="${kak_version}"

    printf '
        echo -debug Local version: %s
        echo -debug Upstream version: %s
    ' "${version}" "${upstream_version}"

    if [ ${#version} -gt ${#upstream_version} ]; then
        version="${version%%-*}"
    fi

    version=$(printf %s "${version}" | sed 's/^v\|\.//g')
    upstream_version=$(printf %s "${upstream_version}" | sed 's/^v\|\.//g')

    if [ "${upstream_version}" -gt "${version}" ]; then
        echo 'echo -debug A new version is available'
    else
        echo 'echo -debug Up to date'
    fi
} }
