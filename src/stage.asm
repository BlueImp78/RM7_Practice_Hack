include

set_inventory:
    SEP #$20
    LDA #$08
    STA $2109  ;set normal BG3 address
    REP #$20
    LDA #$0020
    TSB !obtained_items      ;give exit item
    LDA #$6464               ;give infinite E/W tanks (not really infinite, but who tf is gonna use 100 of them?)
    STA !tank_count
    SEP #$20
    STA $0BA2                ;same for S tanks
    LDA !player_active_held
    BIT #$40                 ;check if Y held
    BNE .set_spawn
    BIT #$10                 ;check if start held
    BEQ .no_button_held

.set_spawn:
    LDA !stage_destination
    CMP #$0A
    BEQ .set_chkpt_3
    CMP #$0B
    BEQ .set_chkpt_3
    LDA #$02
-:
    STA !spawn_destination
    BRA .no_button_held

.set_chkpt_3:
    LDA #$03
    BRA -


.no_button_held:
    LDA !stage_destination
    BNE .not_intro
    JSL clear_boss_and_wpn_vars
    LDA #$01
    STA $0B74   ;skip intro cutscene
    STZ $0B75
    LDA $0B73
    ASL
    PHA
    LDA #$9C
    STA $0B9A  ;needed, we already get coil in intro but without this, its 0 ammo (why would u even use it there???)
    PLA
    REP #$20
    RTL

.not_intro:
    CMP #$09                 ;check if museum
    BNE .check_wily
    STZ $0B74                ;any checkpoint besides 0 there will crash
    STZ $0B75                ;disable wily stealing gutsman cutscene
    BRA +

.check_wily:
    CMP #$0A                 ;check if wily stage
    BCC +
    JSR set_all_weapons
    REP #$20
    BRA set_inventory_done

+: 
    ASL A
    DEC
    DEC
    TAX
    LDA #$9C
    STA !rush_coil  ;always give coil   
    JMP (stages,x)



stages:
    dw freeze
    dw cloud
    dw junk
    dw turbo
    dw slash
    dw shade
    dw burst
    dw spring
    dw museum

set_inventory_done:
    ;hijacked instructions
    REP #$20
    LDA $0B73
    ASL
    RTL

;yandere dev would be proud
freeze:
    STZ !freeze
    LDX !selected_route
    CPX #$02
    BEQ .done
    STA !cloud
    STA !junk
    STA !rush_jet     
.done:
    BRA set_inventory_done

cloud:
    STZ !cloud
    LDX !selected_route
    CPX #$02
    BNE .done
    STA !freeze
    STA !burst
    STA !rush_search
    LDA #$09             ;letters R and H
    TSB !obtained_items

.done:
    BRA set_inventory_done

junk:
    STZ !junk
    STA !cloud
    LDX !selected_route
    CPX #$02
    BNE .done
    STA !freeze
    STA !burst
    STA !rush_search
    LDA #$0B           ;letter R, U and H
    TSB !obtained_items 

.done:
    BRA set_inventory_done

turbo:
    STZ !turbo
    STA !freeze
    STA !cloud
    STA !junk
    STA !burst
    STA !rush_search
    STA !rush_jet 
    STA !shade
    LDX !selected_route
    CPX #$01
    BEQ +
    CPX #$02
    BNE .done
    STA !rush_adaptor
    LDA #$8F             ;e balancer
    TSB !obtained_items
    BRA +
    

.done:
    STA !slash
    STA !spring
+:
    BRL set_inventory_done

slash:
    STZ !slash  
    LDX !selected_route
    CPX #$00
    BNE .hundo_or_spring
    JMP museum
.hundo_or_spring:
    STA !freeze
    STA !cloud
    STA !junk
    STA !burst
    STA !shade
    STA !turbo
    STA !rush_search
    STA !rush_jet
    CPX #$01
    BEQ .done
    STA !rush_adaptor
    STA !proto_shield
    LDA #$CF              ;punch
    TSB !obtained_items
.done
    BRL set_inventory_done

shade:
    STZ !shade
    STA !freeze
    STA !cloud
    STA !junk
    STA !burst
    STA !rush_search
    STA !rush_jet
    LDX #$03
    STX $0B78    ;enable protoman fight always
    LDX !selected_route
    BEQ .done
    CPX #$02
    BNE .normal 
    LDX !shade_visit
    BEQ .normal
    STA !shade
    STA !turbo
    STA !rush_adaptor
    LDA #$CF              ;punch
    TSB !obtained_items  
    BRL set_inventory_done

.normal
    JMP museum
.done:
    STA !slash
    STA !spring
    BRL set_inventory_done

burst:
    STZ !burst
    STA !freeze
    LDX !selected_route
    CPX #$02
    BNE +
    LDA #$08
    TSB !obtained_items  ;letter H
    LDA #$9C
    BRA .done
+:
    STA !cloud
    STA !junk
    STA !rush_jet
.done:
    STA !rush_search
    BRL set_inventory_done

spring:
    STZ !spring
    STA !freeze
    STA !cloud
    STA !junk
    STA !slash
    STA !burst
    STA !rush_search
    STA !rush_jet
    LDX !selected_route
    CPX #$01
    BNE +
    JSR set_all_weapons
    STZ !spring
    BRA .done
+:
    CPX #$02
    BNE .done
    STA !turbo
    STA !shade
    STA !rush_adaptor
    STA !proto_shield
    LDA #$CF
    TSB !obtained_items
    LDA #$84
    TSB $0BA3        ;give beat


.done:
    BRL set_inventory_done

museum:
    STA !freeze
    STA !cloud
    STA !junk
    STA !burst
    STA !rush_search
    STA !rush_jet
    LDX !selected_route
    CPX #$02
    BNE .done
    STA !rush_adaptor
    LDA #$0F             ;all letters
    TSB !obtained_items
.done:
    BRL set_inventory_done


set_all_weapons:
    LDA #$9C 
    STA !freeze
    STA !cloud
    STA !junk
    STA !turbo
    STA !slash
    STA !shade
    STA !burst
    STA !spring
    STA !rush_search
    STA !rush_jet
    STA !rush_coil
    LDX !selected_route      ;check if hundo
    CPX #$02   
    BNE .done
    STA !proto_shield
    STA !rush_adaptor
    LDA #$84
    TSB $0BA3
    LDA #$DF
    TSB !obtained_items
.done:
    RTS


skip_weapon_get:
    SEP #$30        ;hijacked instruction
    LDA #$10
    STA $0C53       ;hijacked instruction
    LDA #$0E
    STA !stage_destination
    STZ $0B7C       ;stop this from going past 1, if it does and reaches 5, sends to credits lmao
    JSL clear_boss_and_wpn_vars
    RTL
   

respawn_at_checkpoint:
    LDA !menu_flag    
    BNE .done                    ;dont run button check while on menu
    LDA $0C53                    ;or during a boss cutscene
    BNE .done
    LDA $A3                      ;check if A+X held
    EOR #$C0
    BEQ .respawn
    BRA .done

;goto previous/next checkpoint if dpad left/right pressed respectively
.respawn
    ;SEP #$20
    LDA $A6
    BIT #$02
    BNE .cycle_left
    BIT #$01
    BNE .cycle_right
    BRA .check_if_released_buttons


.check_if_released_buttons
    LDA $A1
    AND #$C0
    BNE .done
    LDA !spawn_destination
    BRA .update_spawn


.cycle_left:
    LDA !spawn_destination
    DEC
    BPL .update_spawn
    LDA !stage_destination
    CMP #$0A                ;check if wily stage
    BCC +
    CMP #$0C                ;if yes check if wily 3 or 4
    BCS +
    LDA #$03
    BRA .update_spawn

+:
    LDA #$02
    BRA .update_spawn


.cycle_right
    LDA !spawn_destination
    INC
    PHA
    LDA !stage_destination
    CMP #$0A
    BCS .is_wily
--:
    PLA
    CMP #$03
    BNE .update_spawn
-:
    LDA #$00
    BRA .update_spawn


.is_wily:
    CMP #$0C    ;check if wily 3 or 4
    BCS --
    PLA
    CMP #$04
    BNE .update_spawn
    BRA -


.update_spawn
    STA !spawn_destination
    INC $0BCA            ;disable damage for mega man, probably unnecessary but avoids potential issues maybe
    JSL clear_boss_and_wpn_vars
    
.fadeout:
    REP #$20
    LDA #$0080
    TSB $0BCB

.done:
    SEP #$20
    LDA $0BCB
    BEQ .CODE_C00D23
    LDA #$06
    STA $E1
    STZ $E2
    LDA #$01
    STA $E3
    RTL

.CODE_C00D23
    LDA $0BDB
    BEQ .CODE_C00D2E
    LDA #$04
    STA $E1
    STZ $E2
.CODE_C00D2E
    RTL

set_wily4_health:
    LDA !stage_destination
    CMP #$0D                 ;check if wily 4 and if checkpoint 2
    BNE .done
    LDA !spawn_destination
    CMP #$02
    BNE .done                ;if yes, set proper post-refights w.coil ammo and health
    LDA #$17
    STA !player_health
    LDA #$92
    STA !w_coil_ammo
    RTL                      ;if we already set our health, don't restore instructions


;hijacked instructions
.done:
    LDA #$1C
    STA $2E
    RTL

; set_wily4_coil:
;     LDA !stage_destination
;     CMP #$0D               ;check if wily 4 and if checkpoint 2
;     BNE .done
;     LDA !spawn_destination
;     CMP #$02
;     BNE .done             ;if yes, set to spawn with coil selected
;     LDA #$08
;     STA !selected_weapon
;     LDA #$94
;     STA $0C5E
;     STZ $0BC8             ;dont restore STZ $0BC7
;     RTL

; ;hijacked instructions
; .done:
;     STZ $0BC8
;     STZ $0BC7            
;     RTL

force_teleport:
    LDA #$10
    JSL $C30E4E
    RTL


;TODO: make a jump table for this mess later
skip_NPC_cutscenes:
    SEP #$10
    LDX !stage_destination
    CPX #$04
    BNE .check_cloud 
    LDA #$00
    BRA .done

.check_cloud:
    CPX #$02
    BNE .check_shade
    TXA
    SEP #$30    ;hijacked instruction
    BRA .done

.check_shade:
    LDY !room_number
    CPY #$0E
    BNE +
    LDA #$00
    BRA .done
+:    
    CPX #$06     
    BNE .check_wily1
    LDA #$09
    INC $02
    BRA .done

.check_wily1
    CPX #$0A
    BNE ++
    LDA #$03
    BRA .done

++:
    LDA #$05
.done:
    STA $00F2
.done2:
    STZ $3A   ;hijacked instruction
    RTL

skip_bass_death_cutscenes:
    LDA #$01
    STA $00F2


    ;hijacked instructions
    INC $3A
    INC $3A
    RTL

cancel_speech_bubble:
    LDA !stage_destination
    CMP #$04             ;dont disable speech bubble in turbo
    BEQ .restore_bubble
    CMP #$06
    BNE +
    LDA !room_number     ;don't disable speech bubble in proto's room in shade
    CMP #$0E
    BNE +
.restore_bubble:
    LDA #$20
    STA $00C5
    BRA .done
+:
    STZ $00C5
.done:
    RTL          ;don't restore hijacked instructions


cancel_dialogue:
    LDA #$0A     ;hijacked instructions
    STA $2109 


    LDA !stage_destination
    CMP #$04             ;dont disable dialogue in turbo
    BEQ .done
    CMP #$06
    BNE +
    LDA !room_number     ;dont disable dialogue in proto's room
    CMP #$0E 
    BEQ .done
+:
    JML $C0129B
.done:
    RTL