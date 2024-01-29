include

exit_stage:
    LDA #$0E
    STA !stage_destination
    STZ $0B7C         ;stop this from going past 1, if it does and reaches 5, sends to credits lmao
    JSL clear_boss_and_wpn_vars
    RTL