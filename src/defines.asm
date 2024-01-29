include

freerom = $E00000   ;start of expanded rom

;hijacks
hijack_capcom_logo = $C005DB
hijack_intro_movie = $C00B89
hijack_game_start = $C00B33
hijack_title_nmi = $C000B2
hijack_title_init = $C00A94
hijack_title_timer = $C00B6E
hijack_title_audio_toggle = $C00B09
hijack_stage_select_init = $C03345
hijack_stage_select_confirm = $C03534
hijack_stage_select_castle_check = $C03570
hijack_stage_select_every_frame = $C03824
hijack_stage_init = $C0276F
hijack_password_init = $C0674F
hijack_every_frame_on_stg = $C00D10 
hijack_exit_level_check = $C04800
hijack_exit_item = $C04808
hijack_8robo_fanfare = $C3B29A
hijack_castle_fanfare = $C3C7F7
hijack_final_fanfare =  $C17313
hijack_teleport_out = $C30E4F
hijack_lives = $C00E25
hijack_death_pause = $C00D1E
hijack_death_timer_1 = $C1189F
hijack_death_timer_2 = $C118C3
hijack_pit_death_timer = $C118E5
hijack_health_init = $C10F28
hijack_refights_teleport_out = $C07A8C


;routines
play_sound_effect = $C0320D
play_music = $C030BF
fade_screen = $C039BD   ;unclear


;ram
!title_screen_selection = $39

!player_active_released = $A2
!player_active_held = $A4
!player_active_pressed = $00A5

!screen_brightness = $00AD

!title_screen_timer = $E3

!player_health = $0C2E
!w_coil_ammo = $0B93

!stage_destination = $0B73
!spawn_destination = $0B74  
!intro_beaten_flag = $0B76

!8robo_avail_flags = $0B7A

!screen_number = $0B7D  ;unclear, investigate more

!tank_count = $0BA0

!obtained_items = $0BA4

!selected_weapon = $0BC7

;weapons
!freeze = $0B85
!cloud = $0B87
!junk = $0B89
!turbo = $0B8B
!slash = $0B8D
!shade = $0B8F
!burst = $0B91
!spring = $0B93
!proto_shield = $0B95
!rush_search = $0B97
!rush_jet = $0B99
!rush_coil = $0B9B
!rush_adaptor = $0B9F


!menu_flag = $0BD9   

!robo_cutscene_progress = $1DC1
!stage_select_cursor_pos = $1DC4 

!stage_start_timer = $1DF4


;ram used by the hack
!new_stage_destination = $0C20  ;00-04: wily 1-4, 04: museum, 05: intro
!initial_dma_done = $0C22
!cursor_pos = $0C24
!text_to_dma = $0C28
!vram_destination = $0C2A
!bytes_to_transfer = $0C2C
!logo_skip_done = $1FF0
!bg1_nuke_done = $1FF2
!selected_route = $1FF4
!shade_visit = $1FF6           ;00 = normal, 01 = hundo revisit
