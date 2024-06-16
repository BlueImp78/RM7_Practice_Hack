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

org hijack_speech_bubble         ;stop speech bubble from appearing
        JSL cancel_speech_bubble
        NOP

 org hijack_dialogue              ;then cancel text
        JSL cancel_dialogue
        NOP


org hijack_intro_bass_cutscene
        JML force_teleport
        NOP

org hijack_NPC_cutscenes
        JSL skip_NPC_cutscenes
        NOP

org hijack_shade_bass_cutscene
        JSL skip_NPC_cutscenes
        NOP

org hijack_bass_death
        JSL skip_bass_death_cutscene

org hijack_proto_visit_cutscenes
        JSL skip_NPC_cutscenes
        NOP

org hijack_stage_select_init
        JSL clear_boss_and_wpn_vars
        NOP

org hijack_stage_select_confirm
        JSL skip_boss_intro

org hijack_stage_select_shop_input  ;since dialogue has been disabled, shop has to be as well, otherwise softlock
        NOP #7

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

org hijack_stage_nmi
        JSL room_timer
        ;WDM  ;im funny i promise

org hijack_screen_transition_down
        JSL set_timer_flag
        WDM

org hijack_screen_transition_up
        JSL set_timer_flag_transition
        WDM 

org hijack_screen_transition_right
        JSL set_timer_flag_transition
        WDM

org hijack_screen_transition_finished_down
        JSL screen_transition_finish_clear_timer
        WDM

org hijack_screen_transition_finished_up
        JSL screen_transition_finish_clear_timer
        WDM

org hijack_screen_transition_finished_right
        JSL screen_transition_finish_right_clear_timer
        WDM

org hijack_door_transition
        JSL set_timer_flag_door
        WDM

org hijack_door_transition_2
        JSL set_timer_flag_door
        WDM

org hijack_door_transition_3
        JSL set_timer_flag_door
        WDM

org hijack_door_transition_finished
        JSL screen_transition_finish_right_clear_timer
        WDM

org hijack_door_transition_2_finished
        JSL screen_transition_finish_clear_timer
        WDM    

org hijack_door_transition_3_finished
        JSL screen_transition_finish_clear_timer
        WDM    

org hijack_boss_door_transition
        JSL set_timer_flag
        WDM


; org hijack_boss_door_transition_finished
;        JSL boss_door_finished_clear_timer

org hijack_boss_death
        JSL boss_death_draw_timer

org hijack_wily1_bass_death
        JSL wily1_bass_death_draw_timer
        WDM

org hijack_wily1_bass_death_finished
        JSL wily1_bass_death_clear_timer
        WDM

org hijack_wily1_post_bass_transition
        JSL wily1_post_bass_clear_timer

org hijack_fortress_boss_death
        JSL fortress_boss_death_draw_timer
        NOP

org hijack_wily4_teleporters_1
        JSL set_timer_flag_teleporter

org hijack_wily4_teleporters_2
        JSL set_timer_flag_teleporter

org hijack_wily_machine_death
        JSL set_timer_flag_machine_death

org hijack_wily_capsule_death
        JSL set_timer_flag_capsule_death
        
