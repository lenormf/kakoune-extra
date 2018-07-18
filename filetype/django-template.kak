##
## django-template.kak by lenormf
##

# https://docs.djangoproject.com/en/dev/ref/templates/language/
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .+\.html %[
    try %[
        execute-keys \%s \{\%|\{\{ <ret>
        set-option buffer filetype django-template
    ]
]

# Highlighters
# ‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/django-template regions
add-highlighter shared/django-template/code default-region group
add-highlighter shared/django-template/scope region '\{%' '%\}' group
add-highlighter shared/django-template/expansion region '\{\{' '\}\}' group
add-highlighter shared/django-template/comment region '\{#' '#\}' fill comment

add-highlighter shared/django-template/code/ ref html
add-highlighter shared/django-template/scope/ ref python
add-highlighter shared/django-template/expansion/ ref python
add-highlighter shared/django-template/scope/ regex \A\{%|%\}\z 0:meta
add-highlighter shared/django-template/expansion/ regex \A\{\{|\}\}\z 0:meta
add-highlighter shared/django-template/scope/ regex \A\{%\s+((end)?(autoescape|block|comment|csrf_token|cycle|debug|empty|extends|filter|firstof|for|if|ifequal|ifnotequal|ifchanged|include|load|lorem|now|regroup|resetcycle|spaceless|templatetag|url|verbatim|widthratio|with))\b 1:keyword
add-highlighter shared/django-template/expansion/ regex \|(add|addslashes|capfirst|center|cut|date|default|default_if_none|dictsort|dictsortreversed|divisibleby|escape|escapejs|filesizeformat|first|floatformat|force_escape|get_digit|iriencode|join|last|length|length_is|linebreaks|linebreaksbr|linenumbers|ljust|lower|make_list|phone2numeric|pluralize|pprint|random|rjust|safe|safeseq|slice|slugify|stringformat|striptags|time|timesince|timeuntil|title|truncatechars|truncatechars_html|truncatewords|truncatewords_html|unordered_list|upper|urlencode|urlize|urlizetrunc|wordcount|wordwrap|yesno)\b 1:builtin

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=django-template %{
    add-highlighter window/django-template ref django-template
}
hook global WinSetOption filetype=(?!django-template).* %{
    remove-highlighter window/django-template
}
