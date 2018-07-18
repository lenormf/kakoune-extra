##
## powerline.kak by lenormf
## Highlight some modeline items to give them a powerline feel
##

declare-option str powerlinesep ""

evaluate-commands %sh{
    case "${kak_opt_colorscheme}" in
        zenburn)
            readonly StatusLineBackground='black'
            printf %s\\n "
                set-face global PwrBrightR   'rgb:F0DFAF,${StatusLineBackground}+r'
                set-face global PwrBrightIn  'rgb:F0DFAF'
                set-face global PwrBrightOut '${StatusLineBackground},rgb:F0DFAF'
                set-face global PwrLightR    'rgb:808080,rgb:F8F8FF+r'
                set-face global PwrLightIn   'rgb:808080'
                set-face global PwrLightOut  '${StatusLineBackground},rgb:808080'
                set-face global PwrDarkR     'rgb:313131,rgb:CCCCCC+r'
                set-face global PwrDarkIn    'rgb:313131'
                set-face global PwrDarkOut   '${StatusLineBackground},rgb:313131'
            "
        ;;
        gruvbox)
            readonly StatusLineBackground='black'
            printf %s\\n "
                set-face global PwrBrightR   'rgb:D6CFAB,${StatusLineBackground}+r'
                set-face global PwrBrightIn  'rgb:D6CFAB'
                set-face global PwrBrightOut '${StatusLineBackground},rgb:D6CFAB'
                set-face global PwrLightR    'rgb:808080,rgb:F8F8FF+r'
                set-face global PwrLightIn   'rgb:808080'
                set-face global PwrLightOut  '${StatusLineBackground},rgb:808080'
                set-face global PwrDarkR     'rgb:313131,rgb:CCCCCC+r'
                set-face global PwrDarkIn    'rgb:313131'
                set-face global PwrDarkOut   '${StatusLineBackground},rgb:313131'
            "
        ;;
        *) exit 1;;
    esac

    for i in Bright Light Dark; do
        printf %s\\n "
            decl str Pwr${i}SepIn '{Pwr${i}In}${kak_opt_powerlinesep}{Pwr${i}R}'
            decl str Pwr${i}SepOut '{Pwr${i}Out}${kak_opt_powerlinesep}{StatusLine}'
        "
    done
}
