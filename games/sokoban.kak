##
## sokoban.kak by lenormf
## Opens a game of sokoban in a new buffer, using one of the 90 hardcoded levels
##

# Selections description of all the holes on the map
declare-option -hidden str _sokoban_holes

# Colorize the levels
add-highlighter shared/sokoban group
add-highlighter shared/sokoban/ regex @ 0:string
add-highlighter shared/sokoban/ regex '#' 0:comment
add-highlighter shared/sokoban/ regex O 0:variable

define-command -params 1 -docstring %{sokoban <level>: play a game of sokoban on the level passed as parameter
level is an integer between 1 and 90 included} \
    sokoban %{ eval -save-regs '/"|^@m' %{
    evaluate-commands %sh{
        readonly id_level=$(($1))

        ## FIXME: find a way to get this variable dynamically
        case ${id_level} in
            0) printf %s "reg m '${kak_opt__sokoban_level_0}'";;
            1) printf %s "reg m '${kak_opt__sokoban_level_1}'";;
            2) printf %s "reg m '${kak_opt__sokoban_level_2}'";;
            3) printf %s "reg m '${kak_opt__sokoban_level_3}'";;
            4) printf %s "reg m '${kak_opt__sokoban_level_4}'";;
            5) printf %s "reg m '${kak_opt__sokoban_level_5}'";;
            6) printf %s "reg m '${kak_opt__sokoban_level_6}'";;
            7) printf %s "reg m '${kak_opt__sokoban_level_7}'";;
            8) printf %s "reg m '${kak_opt__sokoban_level_8}'";;
            9) printf %s "reg m '${kak_opt__sokoban_level_9}'";;
            10) printf %s "reg m '${kak_opt__sokoban_level_10}'";;
            11) printf %s "reg m '${kak_opt__sokoban_level_11}'";;
            12) printf %s "reg m '${kak_opt__sokoban_level_12}'";;
            13) printf %s "reg m '${kak_opt__sokoban_level_13}'";;
            14) printf %s "reg m '${kak_opt__sokoban_level_14}'";;
            15) printf %s "reg m '${kak_opt__sokoban_level_15}'";;
            16) printf %s "reg m '${kak_opt__sokoban_level_16}'";;
            17) printf %s "reg m '${kak_opt__sokoban_level_17}'";;
            18) printf %s "reg m '${kak_opt__sokoban_level_18}'";;
            19) printf %s "reg m '${kak_opt__sokoban_level_19}'";;
            20) printf %s "reg m '${kak_opt__sokoban_level_20}'";;
            21) printf %s "reg m '${kak_opt__sokoban_level_21}'";;
            22) printf %s "reg m '${kak_opt__sokoban_level_22}'";;
            23) printf %s "reg m '${kak_opt__sokoban_level_23}'";;
            24) printf %s "reg m '${kak_opt__sokoban_level_24}'";;
            25) printf %s "reg m '${kak_opt__sokoban_level_25}'";;
            26) printf %s "reg m '${kak_opt__sokoban_level_26}'";;
            27) printf %s "reg m '${kak_opt__sokoban_level_27}'";;
            28) printf %s "reg m '${kak_opt__sokoban_level_28}'";;
            29) printf %s "reg m '${kak_opt__sokoban_level_29}'";;
            30) printf %s "reg m '${kak_opt__sokoban_level_30}'";;
            31) printf %s "reg m '${kak_opt__sokoban_level_31}'";;
            32) printf %s "reg m '${kak_opt__sokoban_level_32}'";;
            33) printf %s "reg m '${kak_opt__sokoban_level_33}'";;
            34) printf %s "reg m '${kak_opt__sokoban_level_34}'";;
            35) printf %s "reg m '${kak_opt__sokoban_level_35}'";;
            36) printf %s "reg m '${kak_opt__sokoban_level_36}'";;
            37) printf %s "reg m '${kak_opt__sokoban_level_37}'";;
            38) printf %s "reg m '${kak_opt__sokoban_level_38}'";;
            39) printf %s "reg m '${kak_opt__sokoban_level_39}'";;
            40) printf %s "reg m '${kak_opt__sokoban_level_40}'";;
            41) printf %s "reg m '${kak_opt__sokoban_level_41}'";;
            42) printf %s "reg m '${kak_opt__sokoban_level_42}'";;
            43) printf %s "reg m '${kak_opt__sokoban_level_43}'";;
            44) printf %s "reg m '${kak_opt__sokoban_level_44}'";;
            45) printf %s "reg m '${kak_opt__sokoban_level_45}'";;
            46) printf %s "reg m '${kak_opt__sokoban_level_46}'";;
            47) printf %s "reg m '${kak_opt__sokoban_level_47}'";;
            48) printf %s "reg m '${kak_opt__sokoban_level_48}'";;
            49) printf %s "reg m '${kak_opt__sokoban_level_49}'";;
            50) printf %s "reg m '${kak_opt__sokoban_level_50}'";;
            51) printf %s "reg m '${kak_opt__sokoban_level_51}'";;
            52) printf %s "reg m '${kak_opt__sokoban_level_52}'";;
            53) printf %s "reg m '${kak_opt__sokoban_level_53}'";;
            54) printf %s "reg m '${kak_opt__sokoban_level_54}'";;
            55) printf %s "reg m '${kak_opt__sokoban_level_55}'";;
            56) printf %s "reg m '${kak_opt__sokoban_level_56}'";;
            57) printf %s "reg m '${kak_opt__sokoban_level_57}'";;
            58) printf %s "reg m '${kak_opt__sokoban_level_58}'";;
            59) printf %s "reg m '${kak_opt__sokoban_level_59}'";;
            60) printf %s "reg m '${kak_opt__sokoban_level_60}'";;
            61) printf %s "reg m '${kak_opt__sokoban_level_61}'";;
            62) printf %s "reg m '${kak_opt__sokoban_level_62}'";;
            63) printf %s "reg m '${kak_opt__sokoban_level_63}'";;
            64) printf %s "reg m '${kak_opt__sokoban_level_64}'";;
            65) printf %s "reg m '${kak_opt__sokoban_level_65}'";;
            66) printf %s "reg m '${kak_opt__sokoban_level_66}'";;
            67) printf %s "reg m '${kak_opt__sokoban_level_67}'";;
            68) printf %s "reg m '${kak_opt__sokoban_level_68}'";;
            69) printf %s "reg m '${kak_opt__sokoban_level_69}'";;
            70) printf %s "reg m '${kak_opt__sokoban_level_70}'";;
            71) printf %s "reg m '${kak_opt__sokoban_level_71}'";;
            72) printf %s "reg m '${kak_opt__sokoban_level_72}'";;
            73) printf %s "reg m '${kak_opt__sokoban_level_73}'";;
            74) printf %s "reg m '${kak_opt__sokoban_level_74}'";;
            75) printf %s "reg m '${kak_opt__sokoban_level_75}'";;
            76) printf %s "reg m '${kak_opt__sokoban_level_76}'";;
            77) printf %s "reg m '${kak_opt__sokoban_level_77}'";;
            78) printf %s "reg m '${kak_opt__sokoban_level_78}'";;
            79) printf %s "reg m '${kak_opt__sokoban_level_79}'";;
            80) printf %s "reg m '${kak_opt__sokoban_level_80}'";;
            81) printf %s "reg m '${kak_opt__sokoban_level_81}'";;
            82) printf %s "reg m '${kak_opt__sokoban_level_82}'";;
            83) printf %s "reg m '${kak_opt__sokoban_level_83}'";;
            84) printf %s "reg m '${kak_opt__sokoban_level_84}'";;
            85) printf %s "reg m '${kak_opt__sokoban_level_85}'";;
            86) printf %s "reg m '${kak_opt__sokoban_level_86}'";;
            87) printf %s "reg m '${kak_opt__sokoban_level_87}'";;
            88) printf %s "reg m '${kak_opt__sokoban_level_88}'";;
            89) printf %s "reg m '${kak_opt__sokoban_level_89}'";;
            90) printf %s "reg m '${kak_opt__sokoban_level_90}'";;
            *) exit 1;;
        esac
    }

    evaluate-commands %sh{
        if [ -z "${kak_reg_m}" ]; then
            printf %s "
                echo -markup '{Error}No such level: $1!'
            "
            exit 1
        fi

        ## We try to cleanup hooks and highlighters before opening the buffer,
        ## in case they were already set in a previous game
        printf %s "
            try %{ _sokoban-quit }
            edit -scratch *sokoban*
            exec \\%c<c-r>m<esc>
            exec \\%s\\.<ret>
            set-option buffer _sokoban_holes %val{selections_desc}
            _sokoban-set-hooks
            add-highlighter window/sokoban ref sokoban
            exec /@<ret>
        "
    }
} }

define-command -hidden _sokoban-quit %{
    remove-highlighter window/sokoban
    remove-hooks buffer sokoban-input
}

define-command -hidden _sokoban-left %{ eval -save-regs '/"|^@' %{
    exec l
    try %{
        ## is the player against a wall?
        exec -draft h <a-K>#<ret>

        try %{
            ## is the player against a boulder?
            exec -draft h <a-k>o|O<ret>

            try %{
                ## is the boulder against another boulder or a wall?
                exec -draft 2h <a-K>o|O|#<ret>

                ## push the boulder
                exec Ha<space><esc>i<backspace><esc> l
            }
        } catch %{
            exec hd a<space><esc> h
        }
    }
} }

define-command -hidden _sokoban-right %{ eval -save-regs '/"|^@' %{
    exec h
    try %{
        ## is the player against a wall?
        exec -draft l <a-K>#<ret>

        try %{
            ## is the player against a boulder?
            exec -draft l <a-k>o|O<ret>

            try %{
                ## is the boulder against another boulder or a wall?
                exec -draft 2l <a-K>o|O|#<ret>

                ## push the boulder
                exec L a<del><esc> i<space><esc> \;
            }
        } catch %{
            exec a<del><esc> i<space><esc>
        }
    }
} }

define-command -hidden _sokoban-up %{ eval -save-regs '/"|^@' %{
    exec j
    try %{
        ## is the player against a wall?
        exec -draft k <a-K>#<ret>

        try %{
            ## is the player against a boulder?
            exec -draft k <a-k>o|O<ret>

            try %{
                ## is the boulder against another boulder or a wall?
                exec -draft 2k <a-K>o|O|#<ret>

                ## push the boulder
                exec r<space> 2kro jr@
            }
        } catch %{
            exec r<space> kr@
        }
    }
} }

define-command -hidden _sokoban-down %{ eval -save-regs '/"|^@' %{
    exec k
    try %{
        ## is the player against a wall?
        exec -draft j <a-K>#<ret>

        try %{
            ## is the player against a boulder?
            exec -draft j <a-k>o|O<ret>

            try %{
                ## is the boulder against another boulder or a wall?
                exec -draft 2j <a-K>o|O|#<ret>

                ## push the boulder
                exec r<space> 2jro kr@
            }
        } catch %{
            exec r<space>jr@
        }
    }
} }

define-command -hidden _sokoban-on-move %{ eval -draft %{
    ## If all the holes have been covered with boulders, the game is over
    #select %opt{_sokoban_holes}

    ## Change the character of boulders in the holes
    try %{
## FIXME: this should be superseeded by the call above
        select %opt{_sokoban_holes}
        exec -draft so<ret>~
    }
    ## Restore the holes that were erased (player going over them)
    try %{
## FIXME: this should be superseeded by the call above
        select %opt{_sokoban_holes}
        exec -draft <a-K>O|@<ret>r.
    }

    try %{
## FIXME: the replace operation above modifies this selection,
## so we have to restore the points a second time
        select %opt{_sokoban_holes}
        exec -draft <a-K>O<ret>
    } catch %{
        eval -client %val{client} echo -markup "{Information}You win!"
    }
} }

define-command -hidden _sokoban-set-hooks %{
    hook buffer BufClose \*sokoban\* _sokoban-quit

    hook -group sokoban-input buffer NormalKey (<left>|h) _sokoban-left
    hook -group sokoban-input buffer NormalKey (<right>|l) _sokoban-right
    hook -group sokoban-input buffer NormalKey (<up>|k) _sokoban-up
    hook -group sokoban-input buffer NormalKey (<down>|j) _sokoban-down
    hook -group sokoban-input buffer NormalKey (<left>|<right>|<up>|<down>|[hjkl]) _sokoban-on-move
}

declare-option -hidden str _sokoban_level_0 "
#####
#@o.#
#####"

declare-option -hidden str _sokoban_level_1 "
    #####
    #   #
    #o  #
  ###  o##
  #  o o #
### # ## #   ######
#   # ## #####  ..#
# o  o          ..#
##### ### #@##  ..#
    #     #########
    #######"

declare-option -hidden str _sokoban_level_2 "
############
#..  #     ###
#..  # o  o  #
#..  #o####  #
#..    @ ##  #
#..  # #  o ##
###### ##o o #
  # o  o o o #
  #    #     #
  ############"

declare-option -hidden str _sokoban_level_3 "
        ########
        #     @#
        # o#o ##
        # o  o#
        ##o o #
######### o # ###
#....  ## o  o  #
##...    o  o   #
#....  ##########
########"

declare-option -hidden str _sokoban_level_4 "
           ########
           #  ....#
############  ....#
#    #  o o   ....#
# ooo#o  o #  ....#
#  o     o #  ....#
# oo #o o o########
#  o #     #
## #########
#    #    ##
#     o   ##
#  oo#oo  @#
#    #    ##
###########"

declare-option -hidden str _sokoban_level_5 "
        #####
        #   #####
        # #o##  #
        #     o #
######### ###   #
#....  ## o  o###
#....    o oo ##
#....  ##o  o @#
#########  o  ##
        # o o  #
        ### ## #
          #    #
          ######"

declare-option -hidden str _sokoban_level_6 "
######  ###
#..  # ##@##
#..  ###   #
#..     oo #
#..  # # o #
#..### # o #
#### o #o  #
   #  o# o #
   # o  o  #
   #  ##   #
   #########"

declare-option -hidden str _sokoban_level_7 "
       #####
 #######   ##
## # @## oo #
#    o      #
#  o  ###   #
### #####o###
# o  ### ..#
# o o o ...#
#    ###...#
# oo # #...#
#  ### #####
####"

declare-option -hidden str _sokoban_level_8 "
  ####
  #  ###########
  #    o   o o #
  # o# o #  o  #
  #  o o  #    #
### o# #  #### #
#@#o o o  ##   #
#    o #o#   # #
#   o    o o o #
#####  #########
  #      #
  #      #
  #......#
  #......#
  #......#
  ########"

declare-option -hidden str _sokoban_level_9 "
          #######
          #  ...#
      #####  ...#
      #      . .#
      #  ##  ...#
      ## ##  ...#
     ### ########
     # ooo ##
 #####  o o #####
##   #o o   #   #
#@ o  o    o  o #
###### oo o #####
     #      #
     ########"

declare-option -hidden str _sokoban_level_10 "
 ###  #############
##@####       #   #
# oo   oo  o o ...#
#  ooo#    o  #...#
# o   # oo oo #...#
###   #  o    #...#
#     # o o o #...#
#    ###### ###...#
## #  #  o o  #...#
#  ## # oo o o##..#
# ..# #  o      #.#
# ..# # ooo ooo #.#
##### #       # #.#
    # ######### #.#
    #           #.#
    ###############"

declare-option -hidden str _sokoban_level_11 "
          ####
     #### #  #
   ### @###o #
  ##      o  #
 ##  o oo## ##
 #  #o##     #
 # # o oo # ###
 #   o #  # o #####
####    #  oo #   #
#### ## o         #
#.    ###  ########
#.. ..# ####
#...#.#
#.....#
#######"

declare-option -hidden str _sokoban_level_12 "
################
#              #
# # ######     #
# #  o o o o#  #
# #   o@o   ## ##
# #  o o o###...#
# #   o o  ##...#
# ###ooo o ##...#
#     # ## ##...#
#####   ## ##...#
    #####     ###
        #     #
        #######"

declare-option -hidden str _sokoban_level_13 "
   #########
  ##   ##  #####
###     #  #    ###
#  o #o #  #  ... #
# # o#@o## # #.#. #
#  # #o  #    . . #
# o    o # # #.#. #
#   ##  ##o o . . #
# o #   #  #o#.#. #
## o  o   o  o... #
 #o ######    ##  #
 #  #    ##########
 ####"

declare-option -hidden str _sokoban_level_14 "
       #######
 #######     #
 #     # o@o #
 #oo #   #########
 # ###......##   #
 #   o......## # #
 # ###......     #
##   #### ### #o##
#  #o   #  o  # #
#  o ooo  # o## #
#   o o ###oo # #
#####     o   # #
    ### ###   # #
      #     #   #
      ########  #
             ####"

declare-option -hidden str _sokoban_level_15 "
   ########
   #   #  #
   #  o   #
 ### #o   ####
 #  o  ##o   #
 #  # @ o # o#
 #  #      o ####
 ## ####o##     #
 # o#.....# #   #
 #  o..OO. o# ###
##  #.....#   #
#   ### #######
# oo  #  #
#  #     #
######   #
     #####"

declare-option -hidden str _sokoban_level_16 "
#####
#   ##
#    #  ####
# o  ####  #
#  oo o   o#
###@ #o    ##
 #  ##  o o ##
 # o  ## ## .#
 #  #o##o  #.#
 ###   o..##.#
  #    #.O...#
  # oo #.....#
  #  #########
  #  #
  ####"

declare-option -hidden str _sokoban_level_17 "
   ##########
   #..  #   #
   #..      #
   #..  #  ####
  #######  #  ##
  #            #
  #  #  ##  #  #
#### ##  #### ##
#  o  ##### #  #
# # o  o  # o  #
# @o  o   #   ##
#### ## #######
   #    #
   ######"

declare-option -hidden str _sokoban_level_18 "
     ###########
     #  .  #   #
     # #.    @ #
 ##### ##..# ####
##  # ..###     ###
# o #...   o #  o #
#    .. ##  ## ## #
####o##o# o #   # #
  ## #    #o oo # #
  #  o # #  # o## #
  #               #
  #  ###########  #
  ####         ####"

declare-option -hidden str _sokoban_level_19 "
  ######
  #   @####
##### o   #
#   ##    ####
# o #  ##    #
# o #  ##### #
## o  o    # #
## o o ### # #
## #  o  # # #
## # #o#   # #
## ###   # # ######
#  o  #### # #....#
#    o    o   ..#.#
####o  o# o   ....#
#       #  ## ....#
###################"

declare-option -hidden str _sokoban_level_20 "
    ##########
#####        ####
#     #   o  #@ #
# #######o####  ###
# #    ## #  #o ..#
# # o     #  #  #.#
# # o  #     #o ..#
# #  ### ##     #.#
# ###  #  #  #o ..#
# #    #  ####  #.#
# #o   o  o  #o ..#
#    o # o o #  #.#
#### o###    #o ..#
   #    oo ###....#
   #      ## ######
   ########"

declare-option -hidden str _sokoban_level_21 "
#########
#       #
#       ####
## #### #  #
## #@##    #
# ooo o  oo#
#  # ## o  #
#  # ##  o ####
####  ooo o#  #
 #   ##   ....#
 # #   # #.. .#
 #   # # ##...#
 ##### o  #...#
     ##   #####
      #####"

declare-option -hidden str _sokoban_level_22 "
######     ####
#    #######  #####
#   o#  #  o  #   #
#  o  o  o # o o  #
##o o   # @# o    #
#  o ########### ##
# #   #.......# o#
# ##  # ......#  #
# #   o........o #
# # o #.... ..#  #
#  o o####o#### o#
# o   ### o   o  ##
# o     o o  o    #
## ###### o ##### #
#         #       #
###################"

declare-option -hidden str _sokoban_level_23 "
    #######
    #  #  ####
##### o#o #  ##
#.. #  #  #   #
#.. # o#o #  o####
#.  #     #o  #  #
#..   o#  # o    #
#..@#  #o #o  #  #
#.. # o#     o#  #
#.. #  #oo#o  #  ##
#.. # o#  #  o#o  #
#.. #  #  #   #   #
##. ####  #####   #
 ####  ####   #####"

declare-option -hidden str _sokoban_level_24 "
###############
#..........  .####
#..........oo.#  #
###########o #   ##
#      o  o     o #
## ####   #  o #  #
#      #   ##  # ##
#  o#  # ##  ### ##
# o #o###    ### ##
###  o #  #  ### ##
###    o ## #  # ##
 # o  #  o  o o   #
 #  o  o#ooo  #   #
 #  #  o      #####
 # @##  #  #  #
 ##############"

declare-option -hidden str _sokoban_level_25 "
####
#  ##############
#  #   ..#......#
#  # # ##### ...#
##o#    ........#
#   ##o######  ####
# o #     ######@ #
##o # o   ######  #
#  o #ooo##       #
#      #    #o#o###
# #### #ooooo    #
# #    o     #   #
# #   ##        ###
# ######o###### o #
#        #    #   #
##########    #####"

declare-option -hidden str _sokoban_level_26 "
 #######
 #  #  #####
##  #  #...###
#  o#  #...  #
# o #oo ...  #
#  o#  #... .#
#   # o########
##o       o o #
##  #  oo #   #
 ######  ##oo@#
      #      ##
      ########"

declare-option -hidden str _sokoban_level_27 "
 #################
 #...   #    #   ##
##.....  o## # #o #
#......#  o  #    #
#......#  #  # #  #
######### o  o o  #
  #     #o##o ##o##
 ##   o    # o    #
 #  ## ### #  ##o #
 # o oo     o  o  #
 # o    o##o ######
 #######  @ ##
       ######"

declare-option -hidden str _sokoban_level_28 "
         #####
     #####   #
    ## o  o  ####
##### o  o o ##.#
#       oo  ##..#
#  ###### ###.. #
## #  #    #... #
# o   #    #... #
#@ #o ## ####...#
####  o oo  ##..#
   ##  o o  o...#
    # oo  o #  .#
    #   o o  ####
    ######   #
         #####"

declare-option -hidden str _sokoban_level_29 "
#####
#   ##
# o  #########
## # #       ######
## #   o#o#@  #   #
#  #      o #   o #
#  ### ######### ##
#  ## ..O..... # ##
## ## O.O..O.O # ##
# o########## ##o #
#  o   o  o    o  #
#  #   #   #   #  #
###################"

declare-option -hidden str _sokoban_level_30 "
       ###########
       #   #     #
#####  #     o o #
#   ##### o## # ##
# o ##   # ## o  #
# o  @oo # ##ooo #
## ###   # ##    #
## #   ### #####o#
## #     o  #....#
#  ### ## o #....##
# o   o #   #..o. #
#  ## o #  ##.... #
#####   ######...##
    #####    #####"

declare-option -hidden str _sokoban_level_31 "
  ####
  #  #########
 ##  ##  #   #
 #  o# o@o   ####
 #o  o  # o o#  ##
##  o## #o o     #
#  #  # #   ooo  #
# o    o  o## ####
# o o #o#  #  #
##  ###  ###o #
 #  #....     #
 ####......####
   #....####
   #...##
   #...#
   #####"

declare-option -hidden str _sokoban_level_32 "
      ####
  #####  #
 ##     o#
## o  ## ###
#@o o # o  #
#### ##   o#
 #....#o o #
 #....#   o#
 #....  oo ##
 #... # o   #
 ######o o  #
      #   ###
      #o ###
      #  #
      ####"

declare-option -hidden str _sokoban_level_33 "
 ###########
 #     ##  #
 #   o   o #
#### ## oo #
#   o #    #
# ooo # ####
#   # # o ##
#  #  #  o #
# o# o#    #
#   ..# ####
####.. o #@#
#.....# o# #
##....#  o #
 ##..##    #
  ##########"

declare-option -hidden str _sokoban_level_34 "
 #########
 #....   ##
 #.#.#  o ##
##....# # @##
# ....#  #  ##
#     #o ##o #
## ###  o    #
 #o  o o o#  #
 # #  o o ## #
 #  ###  ##  #
 #    ## ## ##
 #  o #  o  #
 ###o o   ###
   #  #####
   ####"

declare-option -hidden str _sokoban_level_35 "
############ ######
#   #    # ###....#
#   oo#   @  .....#
#   # ###   # ....#
## ## ###  #  ....#
 # o o     # # ####
 #  o o##  #      #
#### #  #### # ## #
#  # #o   ## #    #
# o  o  # ## #   ##
# # o o    # #   #
#  o ## ## # #####
# oo     oo  #
## ## ### o  #
 #    # #    #
 ###### ######"

declare-option -hidden str _sokoban_level_36 "
            #####
#####  ######   #
#   ####  o o o #
# o   ## ## ##  ##
#   o o     o  o #
### o  ## ##     ##
  # ##### #####oo #
 ##o##### @##     #
 # o  ###o### o  ##
 # o  #   ###  ###
 # oo o #   oo #
 #     #   ##  #
 #######.. .###
    #.........#
    #.........#
    ###########"

declare-option -hidden str _sokoban_level_37 "
###########
#......   #########
#......   #  ##   #
#..### o    o     #
#... o o #   ##   #
#...#o#####    #  #
###    #   #o  #o #
  #  oo o o  o##  #
  #  o   #o#o ##o #
  ### ## #    ##  #
   #  o o ## ######
   #    o  o  #
   ##   # #   #
    #####@#####
        ###"

declare-option -hidden str _sokoban_level_38 "
      ####
####### @#
#     o  #
#   o## o#
##o#...# #
 # o...  #
 # #. .# ##
 #   # #o #
 #o  o    #
 #  #######
 ####"

declare-option -hidden str _sokoban_level_39 "
             ######
 #############....#
##   ##     ##....#
#  oo##  o @##....#
#      oo o#  ....#
#  o ## oo # # ...#
#  o ## o  #  ....#
## ##### ### ##.###
##   o  o ##   .  #
# o###  # ##### ###
#   o   #       #
#  o #o o o###  #
# ooo# o   # ####
#    #  oo #
######   ###
     #####"

declare-option -hidden str _sokoban_level_40 "
    ############
    #          ##
    #  # #oo o  #
    #o #o#  ## @#
   ## ## # o # ##
   #   o #o  # #
   #   # o   # #
   ## o o   ## #
   #  #  ##  o #
   #    ## oo# #
######oo   #   #
#....#  ########
#.#... ##
#....   #
#....   #
#########"

declare-option -hidden str _sokoban_level_41 "
           #####
          ##   ##
         ##     #
        ##  oo  #
       ## oo  o #
       # o    o #
####   #   oo #####
#  ######## ##    #
#.            ooo@#
#.# ####### ##   ##
#.# #######. #o o##
#........... #    #
##############  o #
             ##  ##
              ####"

declare-option -hidden str _sokoban_level_42 "
     ########
  ####      ######
  #    ## o o   @#
  # ## ##o#o o o##
### ......#  oo ##
#   ......#  #   #
# # ......#o  o  #
# #o...... oo# o #
#   ### ###o  o ##
###  o  o  o  o #
  #  o  o  o  o #
  ######   ######
       #####"

declare-option -hidden str _sokoban_level_43 "
        #######
    #####  #  ####
    #   #   o    #
 #### #oo ## ##  #
##      # #  ## ###
#  ### o#o  o  o  #
#...    # ##  #   #
#...#    @ # ### ##
#...#  ###  o  o  #
######## ##   #   #
          #########"

declare-option -hidden str _sokoban_level_44 "
 #####
 #   #
 # # #######
 #      o@######
 # o ##o ###   #
 # #### o    o #
 # ##### #  #o ####
##  #### ##o      #
#  o#  o  # ## ## #
#         # #...# #
######  ###  ...  #
     #### # #...# #
          # ### # #
          #       #
          #########"

declare-option -hidden str _sokoban_level_45 "
##### ####
#...# #  ####
#...###  o  #
#....## o  o###
##....##   o  #
###... ## o o #
# ##    #  o  #
#  ## # ### ####
# o # #o  o    #
#  o @ o    o  #
#   # o oo o ###
#  ######  ###
# ##    ####
###"

declare-option -hidden str _sokoban_level_46 "
##########
#        ####
# ###### #  ##
# # o o o  o #
#       #o   #
###o  oo#  ###
  #  ## # o##
  ##o#   o @#
   #  o o ###
   # #   o  #
   # ##   # #
  ##  ##### #
  #         #
  #.......###
  #.......#
  #########"

declare-option -hidden str _sokoban_level_47 "
         ####
 #########  ##
##  o      o #####
#   ## ##   ##...#
# #oo o oo#o##...#
# #   @   #   ...#
#  o# ###oo   ...#
# o  oo  o ##....#
###o       #######
  #  #######
  ####"

declare-option -hidden str _sokoban_level_48 "
  #########
  #O.O#O.O#
  #.O.O.O.#
  #O.O.O.O#
  #.O.O.O.#
  #O.O.O.O#
  ###   ###
    #   #
###### ######
#           #
# o o o o o #
## o o o o ##
 #o o o o o#
 #   o@o   #
 #  #####  #
 ####   ####"

declare-option -hidden str _sokoban_level_49 "
       ####
       #  ##
       #   ##
       # oo ##
     ###o  o ##
  ####    o   #
###  # #####  #
#    # #....o #
# #   o ....# #
#  o # #.O..# #
###  #### ### #
  #### @o  ##o##
     ### o     #
       #  ##   #
       #########"

declare-option -hidden str _sokoban_level_50 "
      ############
     ##..    #   #
    ##..O o    o #
   ##..O.# # # o##
   #..O.# # # o  #
####...#  #    # #
#  ## #          #
# @o o ###  #   ##
# o   o   # #   #
###oo   # # # # #
  #   o   # # #####
  # o# #####      #
  #o   #   #    # #
  #  ###   ##     #
  #  #      #    ##
  ####      ######"

declare-option -hidden str _sokoban_level_51 "
 #########
 #       #
 # o oo o#
### #  o #
#.#   oo ##
#.###   o #
#.#. o ## ####
#...  o## o  #
#...o   o    #
#..###o### #@#
#..# #     ###
#### #######"

declare-option -hidden str _sokoban_level_52 "
           ########
           #......#
   ####    #......#
   #  #########...#
   # o   o    #...#
   #  # # # # #   #
##### # # #@# #   #
#   # ### ### ## ##
#    o # o o o # #
# ooo  o   #     #
#   # ###o###o## #
### #  o   #     #
 ## o  # o o o ###
 #  # ### ### ##
 # o          #
 #  ###########
 ####"

declare-option -hidden str _sokoban_level_53 "
##################
#                ##
# o#   o ##  o    #
#    o###    # oo #
#.###     o o ##  ##
#...#  #  #    #o  #
#..##oo#### o  #   #
#...#      o ##  ###
#...o  ###  #    # #
##..  o#  ##   ##@ #
 ##.#              #
  ##################"

declare-option -hidden str _sokoban_level_54 "
####################
#   #    #   #   #@#
# o      o   o   # #
## ###..## ###     #
#   #....#o#  o### #
# o #....#  o  o o #
#   #....# # # o o #
#   ##..##   #o#   #
##o##    ##  #  #o##
#   o  o     #  #  #
#   #    #   #     #
####################"

declare-option -hidden str _sokoban_level_55 "
####################
#    @##      #   ##
#    ##    o    o ##
#  ###....# # #  ###
#   #....# # # o   #
### #...#  #       #
##  ##.#     o   o #
##  o o ###  # # ###
## o       # # o   #
#### o  o# # # # o #
####         # #  ##
####################"

declare-option -hidden str _sokoban_level_56 "
####################
#  #  ##    #   @###
##    o    # o###  #
##o# o ##o# o o    #
#   o#    o      ###
# ##   o ###  #....#
# # o# # # # #....##
#    o o #  #....###
##o ###  o #....####
#  # o        ######
#      # #    ######
####################"

declare-option -hidden str _sokoban_level_57 "
####################
#@     ###   #  #  #
# # #  #  o  o     #
#####     # o o#o# #
#.#..#    ##o o    #
#.....    o   #   ##
#.....    ###o##o###
#.#..#    o    #   #
#####     #  #o  o #
#####  #  o    o o #
#####  #  #  #  #  #
####################"

declare-option -hidden str _sokoban_level_58 "
####################
##...   ## #    #  #
#....         o ## #
#....# # #o###o    #
#...#    #       # #
##.#  #o #     o## #
#  #  # o o ###  o #
#     o  o #  # ## #
## # ## #oo# o#  # #
#  #   o o #      ##
#    #     #  #   @#
####################"

declare-option -hidden str _sokoban_level_59 "
####################
#   #  #@# ##  #####
# # #  o    o  #####
# #    ###### o  ###
#   #  #....#  oo  #
##o##o##....#      #
#      #....##o##o##
#  oo  #....#      #
# o  o  #  #  ###  #
#####  o   o    o  #
##### #    #  #   ##
####################"

declare-option -hidden str _sokoban_level_60 "
####################
# #     #          #
#       o  ## ### ##
#####  ##   o  o   #
##..##  # # o # #  #
#....  o     ##o# ##
#....  o#####   #o##
##..# #  #   #  o  #
###.# #  o   o  # @#
##  o  o #   #  ####
##       ###########
####################"

declare-option -hidden str _sokoban_level_61 "
####################
#     ###..###     #
# oo  ###..###  o@ #
#  # ##......#  o  #
#     #......#  o  #
####  ###..######o #
#   ooo #..#    #  #
# o#   o  o  oo #o #
#  #  ## o  ##  #  #
# o    o ## o    o #
#  #  ##    ##  #  #
####################"

declare-option -hidden str _sokoban_level_62 "
####################
#    #  # #  #  #  #
# @# # ## o   o   ##
#### #    #  # o   #
#    # ## #o ## ## #
#      o   o   o   #
#..###oo## o##o ## #
#..#.#  # o   o #  #
#....# oo   ##o ####
#....#  #####      #
#...###        ##  #
####################"

declare-option -hidden str _sokoban_level_63 "
####################
#....#       #  #  #
#....# # o  o      #
#.... ##  o# # o#o #
#...#   o   o#  o  #
#..####  # o   oo  #
#      #### #### ###
#        #   #     #
# ##   #   o # o o #
# ##    o ## o  o  #
#     @#     #   # #
####################"

declare-option -hidden str _sokoban_level_64 "
####################
#....###           #
#....##### #  #o# ##
#....###   #o  o   #
#....###    o  #oo##
##  #### o#  #o o  #
##  ####  o  o  #  #
#@  ####o###o## o  #
##        #  #  o  #
##   ###  #  o  ####
########  #  #     #
####################"

declare-option -hidden str _sokoban_level_65 "
####################
#     #     @#...###
#     #      ##...##
# # # ##o## ## ....#
#   o #   ooo  ....#
###o### oo  ### ##.#
#     o  #    # ####
#  o  #  ###  # #  #
## #o##    o  oo   #
#   o ##   #  # #  #
#     #    #  #    #
####################"

declare-option -hidden str _sokoban_level_66 "
####################
#     #  #...#@    #
# #       ....#    #
#  o  #   #....#   #
# ##o#### ##....#  #
# o   o  #  #...#  #
# oo #   #   # oo  #
###  ooo#   oo  o  #
# o  #  #    # o#  #
#   o#  #       o  #
#  #    #    #  #  #
####################"

declare-option -hidden str _sokoban_level_67 "
####################
#####@###.##...##  #
#####o  ..#...#    #
####    ......#  o #
###  o #.....## # ##
##  oo# #####  o o #
## o# o    ##  oo  #
##  #  #    # o  o #
##   oo ### #o##   #
## o#      o o  o ##
###    #    #    ###
####################"

declare-option -hidden str _sokoban_level_68 "
####################
#@     #   #       #
## ### ##  #### # ##
#    # #  oo       #
#  # # # o # o ## ##
#     o #  #oo #   #
#  ###  #      ## ##
#..#.# o #  o #    #
#..#.#  o # ## oo  #
#....##   oo  o  # #
#.....##        #  #
####################"

declare-option -hidden str _sokoban_level_69 "
####################
#  #      #   #   ##
# o# o o ##...o  o #
#  o  # ##....# o  #
# ## o ##....#   o #
# o    #....## o   #
# o##  #...#       #
#   ooo##o##  ### ##
# # #  #   #  #    #
# o #  o  ##       #
#    #    #@       #
####################"

declare-option -hidden str _sokoban_level_70 "
####################
#  #  # #    #  #  #
#   o      o o     #
## #  #o###o##  ## #
#   o     o  #  o  #
# ###o##o#   # o   #
# #   o o  ###### o#
# o  oo o  #@#.#...#
# #     #  # #.#...#
# ########## #.....#
#            #.....#
####################"

declare-option -hidden str _sokoban_level_71 "
####################
#  #     #  ##    ##
# o#   o #     ##  #
# o  o  #..#     o #
# o o  #....#   # ##
# o#  #......### o #
#   #  #....#  #o  #
# o  ####..#   #   #
## o   ## # # o  o##
### o    o#@o o#   #
####   #       #   #
####################"

declare-option -hidden str _sokoban_level_72 "
####################
#      ....#    ####
#      ....        #
# # ##########     #
# #o   #      ###..#
#  o   #oo###   #..#
# o ### o   o   #..#
# o #   o o #  ##..#
#  #  oo # o ##   ##
#@## o#  o  o     ##
##       ##   #  ###
####################"

declare-option -hidden str _sokoban_level_73 "
####################
#        #   #@ #  #
# oo  #oo# # #  ## #
#  # o o #oo #     #
## #  #  # # #  #  #
#   ##       #     #
#   # o #   #   #  #
# o #o #   #  o #..#
##o #  ####    #...#
#  o          #....#
#   #  #     #.....#
####################"

declare-option -hidden str _sokoban_level_74 "
####################
#     #   #####    #
## o  #   ####  o  #
#### oo   #..#  #  #
#  o  o  ##..#### ##
# o   ###....   oo #
#  #o#   ....# # o #
# #  # o ..###o#   #
# #   o #..#   ##  #
#   o#  ####   # o##
# #  #    @#      ##
####################"

declare-option -hidden str _sokoban_level_75 "
####################
#   #   #    #   #@#
#   o  o     # o # #
##o# o### #    oo# #
#  #  #.###  #o o  #
#  #o#....#  # ### #
# o  #.....##    # #
##o  #.#....#oo o  #
#  ######..## #  # #
#  o         o ### #
#   #   #        # #
####################"

declare-option -hidden str _sokoban_level_76 "
####################
# # # #   #@##   # #
#             o    #
#  ##o# ##### o # ##
##    ##.....#  #  #
##o##o#.....###o#o #
#   # ##.....#  # ##
#  o    ##..##  #  #
# o #   o   o  ooo #
## o  o# #  #  o   #
#   ##   #  #      #
####################"

declare-option -hidden str _sokoban_level_77 "
####################
#    ##   #    #   #
#  o  o     ## o   #
## #####  .###### ##
 # ##  ##....#### ##
## ##o ###..##     #
#      #... .# o o #
# o ## ## . ### ####
# # o    #.## # #
# o o #   .#### ##
# #  ## # ##  #  ##
#######  o##o   o #
      ##      o #@#
       #  ## ######
       #######"

declare-option -hidden str _sokoban_level_78 "
       ###########
       #         #
       #    o o  #
###### # o ##### #
#    ##### o  ##o#
#       o o      #
#          ## ## #
#    ##@##### ## #
#    ####   # ## ##
#....#      # o   #
#....#      #     #
######      #######"

declare-option -hidden str _sokoban_level_79 "
#############
#           #
# ### oo    #
#   # o  o  #
#  o####o######
# o ##        #####
#  oo o        ...#
### ## oo#     ...#
  # ##   #     ...#
  #      #     ...#
  ###@#############
    ###"

declare-option -hidden str _sokoban_level_80 "
  #################
###@##         ...#
#    #         ...#
# o  #         ...#
# oo #         ...#
## o ###o##########
 # ###  o #
##   o  o #
#  o #  o #
# o  #    #
#  o #    #
#    #    #
###########"

declare-option -hidden str _sokoban_level_81 "
              #####
     ##########   #
     #        #   #
     #  o o    oo #
     # ##### ## o #
     #oo   #o## o #
     # ### # ##o  #
###### ### o o    #
#....        ##   #
#....        ######
#....        #
###########@##
          ###"

declare-option -hidden str _sokoban_level_82 "
    ######
 ####    #
 #    ## #
 # o     #
### #### ########
#  o   o ##  ...#
#   oo oo    ...#
#    o  o##  ...#
##@## ## ##  ...#
 ###  o  ########
 #   oo  #
 #    #  #
 #########"

declare-option -hidden str _sokoban_level_83 "
####### #########
#     # #   ##  #
# ### # #   o   #
# # o ###   o   #
#   oo      ##o #
#    ####   ##  #
#@############ ##
###..    #####o #
  #..    ####   #
  #..       oo  #
  #..    #### o #
  #..    #  #   #
  ########  #####"

declare-option -hidden str _sokoban_level_84 "
#######
#     ##########
#     #    #  ##
# o   #   o o  #
#  o  #  o ##  #
# oo  ##o o    #
## #  ## #######
## #  ##    ...#
#  #o       ...#
#   oo      ...#
#     ##@#  ...#
################"

declare-option -hidden str _sokoban_level_85 "
############
#      #   ##
# o  o   #  ######
####  #####      #
 #..  #     #### #
 #.####  ####    #
 #....    #  o ####
 # ...#   # ooo#  ##
###.#### ##  o@o   #
#     ##### o #    #
# #.# o      o###o #
# #.########  #  o #
# #..        ##  o #
# # ####### o # #  #
#   #     #       ##
#####     ##########"

declare-option -hidden str _sokoban_level_86 "
################
#       #@ #   #
# # # # # o  oo#
# #...# #ooo   #
#  ...# # o  oo##
# ##.## # ##    #
# #...     o    #
# ## ###  #######
#    # ####
######"

declare-option -hidden str _sokoban_level_87 "
    #####
 ####   ## #####
 #  o    ###   #
 # o@o o    o  #
 # #o######## ##
 # #  o  #     #
 # # o o # #   #
## #  o# # #####
#  ##    #     #
#    o # ###   #
##### ##  #....#
#    o     ....#
#         #....#
################"

declare-option -hidden str _sokoban_level_88 "
#############
#........####
#...#### #  #####
#...#  ###    o #
#...oo     o o  #
#  .#  o o# o  ##
#...# #o#   o  #
#.# # o   o    #
#.  #o###o####o#
##  #   o o    #
 #  #  o@o  #  #
 #  # #### o  o#
 #  #    ###   #
 #  # oo # #####
 #  #    #
 #########"

declare-option -hidden str _sokoban_level_89 "
 ##################
 #   o       ...#.##
 #       ####..... #
 # #######  #..... #
 # #    o o ##....##
 # #  o # # ###...#
 # # o@o o  ##### #
## #  o  o oo   o #
#  #o# o#   # o## #
# ##    ## ## o # #
# # o# o o  #     #
# #         #######
# ########o##   #
#        #  o   #
########    #####
       ###  #
         ####"

declare-option -hidden str _sokoban_level_90 "
####################
#..#    #          #
#.o  o  #oo  o## o##
#.o#  ###  ## ##   #
#  # o #  oo   o   #
# ###  # #  #o  ####
#  ## # o   #@ #   #
# o    o  ##.##  o #
#  # o# o# o     ###
#  #  #  #   ###   #
#  ######## #      #
#           #  #.#.#
##o########o#   ...#
#    .O  #    ##.#.#
# .O...O   o  .....#
####################"
