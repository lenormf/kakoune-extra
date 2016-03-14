##
## mustache.kak by lenormf
## Compile all the mustache variables of the current buffer
##

def -hidden _mustache-expand-variable %{
    try %{
        exec -draft s(?<lt>=\")([^\\\"]|\\\\|\\\")*(?=\")<ret> \"vy
        try %{
            exec -draft s\"([^\\\"]|\\\\|\\\")*\"\h*\K[^\n]*<ret> \"py
        } catch %{
            reg p ''
        }
    } catch %{
        echo -color Error "Unable to select variable from the context"
    }
    %sh{
        key="${kak_selection%%:*}"
        pattern="${kak_reg_p}"

        echo "exec \% s\{\{${key}\}\}<ret> \\\"v<a-R> ${pattern//;/\\;}"
    }
}

# This function parses the context, expands all the variables and finally removes the context
# A JSON-like type object is expected on line 1 of the buffer, e.g.
# {
#	abc: "def" ~
#	foo: "123"
# }
# All variables have to be on their own line,
# the variable name must not be enclosed in double quotes,
# the value must be enclosed in double quotes (escapable)
# An optional list of keys that will be passed to `exec` can be specified after the value string
def mustache-compile -docstring "Expand all the mustache variables of the current buffer" %{
    eval -try-client %val{client} -draft %{
        try %{
            exec gg <a-a>B s^\h*\K[\w_]+\h*:\h*\"([^\\\"]|\\\\|\\\")*\"[^\n]*<ret>
            eval -draft -itersel -save-regs '/"|^@vp' _mustache-expand-variable
            exec gg <a-a>Bdd
        } catch %{
            echo -color Error "An error occured, is there a context at the head of the buffer ?"
        }
    }
}
