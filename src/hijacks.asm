include

;  org hijack_capcom_logo
;     JSR $0B9F
;     ;NOP

org hijack_game_start
    JSL skip_intro
    JSR $39BD
    JSR $0B64
    NOP #9

org hijack_title_timer
    JSL stop_title_fadeout
    
org hijack_stage_select_init
    JSL clear_boss_and_wpn_vars
    NOP

org hijack_stage_select_confirm
    JSL skip_boss_intro

org hijack_stage_init
    JSL set_inventory

org hijack_exit_item
    JSL exit_stage
    NOP

org hijack_8robo_fanfare
    JSL force_teleport    

org hijack_castle_fanfare
    LDA #$01
    STA $18
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

org hijack_final_fanfare
    JSL force_teleport

org hijack_teleport_out
    JSL skip_weapon_get
    NOP

org hijack_lives  ;stop deaths from deducting lives
    NOP
    NOP
    NOP

org hijack_death_pause  ;remove pause for slightly faster death animation
    LDA #$01

org hijack_death_timer_1  ;shorten time it takes for death particles to spawn
    LDA #$14             

org hijack_death_timer_2  ;shorten time it takes to respawn after death particles spawn
    LDA #$0A

org hijack_pit_death_timer  ;same for pit deaths
    LDA #$0A

org hijack_every_frame_on_stg
    JSR $0E48
    JSL respawn_at_checkpoint
    RTS

org hijack_exit_level_check   ;enable exit in intro, museum and wily stages
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

org hijack_stage_select_castle_check  ;skip castle cutscenes
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

org hijack_stage_select_every_frame
    JSL idk
    
org hijack_health_init
    JSL set_wily4_health

; org hijack_weapon_init
;     JSL set_wily4_coil
;     NOP
;     NOP

org hijack_refights_teleport_out  ;refight capsules never close
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP


org hijack_title_init
    JSL upload_title_text
    NOP
    NOP

org hijack_title_nmi
    JSL nuke_title_bg1_vram
    NOP

org hijack_title_audio_toggle   ;default to stereo/disable toggling the option
    NOP #22


org hijack_password_init
    JMP $684A   ;skip password screen


org hijack_intro_movie
    NOP
    NOP