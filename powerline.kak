##
## powerline.kak by lenormf
## Highlight some modeline items to give them a powerline feel
##

decl str powerlinesep ""

%sh{
    case "${kak_opt_colorscheme}" in
        zenburn)
            readonly StatusLineBackground='black'
            printf %s\\n "
                face PwrBrightR   'rgb:F0DFAF,${StatusLineBackground}+r'
                face PwrBrightIn  'rgb:F0DFAF'
                face PwrBrightOut '${StatusLineBackground},rgb:F0DFAF'
                face PwrLightR    'rgb:808080,rgb:F8F8FF+r'
                face PwrLightIn   'rgb:808080'
                face PwrLightOut  '${StatusLineBackground},rgb:808080'
                face PwrDarkR     'rgb:313131,rgb:CCCCCC+r'
                face PwrDarkIn    'rgb:313131'
                face PwrDarkOut   '${StatusLineBackground},rgb:313131'
            "
        ;;
        gruvbox)
            readonly StatusLineBackground='black'
            printf %s\\n "
                face PwrBrightR   'rgb:D6CFAB,${StatusLineBackground}+r'
                face PwrBrightIn  'rgb:D6CFAB'
                face PwrBrightOut '${StatusLineBackground},rgb:D6CFAB'
                face PwrLightR    'rgb:808080,rgb:F8F8FF+r'
                face PwrLightIn   'rgb:808080'
                face PwrLightOut  '${StatusLineBackground},rgb:808080'
                face PwrDarkR     'rgb:313131,rgb:CCCCCC+r'
                face PwrDarkIn    'rgb:313131'
                face PwrDarkOut   '${StatusLineBackground},rgb:313131'
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
