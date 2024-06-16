include

;"it just works"
skip_boss_intro:
    REP #$30
    LDA !stage_destination
    ASL A
    DEC
    DEC
    TAX
    LDA.l robot_master_table,x
    TAX
    PHD
    LDA #$0000
    PHA
    PLD
    LDA $7E0000,x
    ORA #$0080
    STA $00,x
    PLD
    SEP #$30
    LDA !cursor_pos
    CMP #$01           ;check if cursor on wily
    BNE .done
    LDA !new_stage_destination
    CMP #$04
    BCS .check_intro_or_museum
    CLC
    ADC #$0A
    STA !stage_destination
    BRA .done

.check_intro_or_museum:
    CMP #$05
    BEQ .set_intro
    LDA #$09
    BRA +

.set_intro:
    JSL clear_boss_and_wpn_vars
    LDA #$00    
    STA !intro_beaten_flag
+:
    STA !stage_destination

.done:
    ;hijacked instructions (LDA #$3C changed to 01 for faster transition into stage)
    LDA #$01  
    STA $34
    RTL


;value in these addresses are also used for weapons as a word
;to tell if they're available + their current ammo
robot_master_table:
    dw !freeze
    dw !cloud
    dw !junk
    dw !turbo
    dw !slash
    dw !shade
    dw !burst
    dw !spring


clear_boss_and_wpn_vars:
    STZ !freeze
    STZ !cloud
    STZ !junk
    STZ !turbo
    STZ !slash
    STZ !shade
    STZ !burst
    STZ !spring
    STZ !rush_jet
    STZ !rush_search
    STZ !rush_adaptor
    STZ !proto_shield
    STZ !obtained_items
    STZ $0BA3               ;remove beat
    STZ $0B78               ;clear protoman visit flags
    JSR clear_timer_vars    ;also clear timer vars


    ;hijacked instructions
    LDA #$01
    STA $1DC4
    RTL


;probably dont need to clear every single one of them, but better safe than sorry
clear_timer_vars:
    STZ !timer_digit_1
    STZ !timer_digit_2
    STZ !timer_digit_3
    STZ !timer_digit_4
    STZ !timer_seconds
    STZ !timer_ms
    STZ !timer_draw_flag
    STZ !timer_control
    STZ !timer_clear_flag
    STZ !display_timer_seconds
    STZ !display_timer_ms
    STZ !timer_onscreen_flag
    RTS


;the SNES'S PPU dev should burn
idk:
    LDA #$00
    STA $2130
    STA $2131   ;disable color math to highlight the text
    LDA #$5C
    STA $2109   ;set bg3 tilemap address
    LDA #$17
    STA $212C   ;move shit to main screen
    LDA #$00
    STA $212D   ;and off sub screen
    LDA $1DDF
    XBA         ;XBA nonsense to get our cursor position (blame capcom)
    LDA $1DE1
    REP #$20
    CMP #$0101
    BEQ .cursor_on_wily
    STZ !cursor_pos
    LDA #$0001
    STA $00C6
    LDX !selected_route
    CPX #$02
    BNE .nuke_bg3
    SEP #$20
    LDA $1DDF
    XBA         ;IM LOSING MY MIND
    LDA $1DE1
    REP #$20
    CMP #$0202
    BEQ .cursor_on_shade
    STZ !cursor_pos
    REP #$20
    LDA #$0001
    STA $00C6     ;hide BG3


.nuke_bg3:
    ;nuke bg3 vram if not on shade or wily
    LDA #$E800
    STA !text_to_dma
    LDA #$5D2C
    STA !vram_destination
    LDA #$0500
    STA !bytes_to_transfer
    JSR DMA_to_VRAM
    STZ !initial_dma_done
    STZ !new_stage_destination
    STZ !shade_visit
    JMP text_done

.cursor_on_shade:
    SEP #$20
    LDA #$02
    STA !cursor_pos
    LDA #$09
    STA $00C6       ;bring bg3 to front
    JSL check_buttons
    BRA pain

.cursor_on_wily:
    SEP #$20
    LDA #$01
    STA !cursor_pos
    LDA #$09
    STA $00C6       ;bring bg3 to front
    JSL check_buttons


pain: 
    LDA !cursor_pos
    CMP #$01
    BEQ .dma_wily
    CMP #$02
    BEQ .dma_shade
    BRL text_done

.dma_wily
    LDA !initial_dma_done
    BNE .dma_done
    REP #$20
    LDA #$E000              ;wily toggle text
    STA !text_to_dma
    LDA #$5D2C
    STA !vram_destination   ;above wily's face
    LDA #$0012
    STA !bytes_to_transfer
    JSR DMA_to_VRAM

    REP #$20
    LDA #$E06C             ;"L/R: Swap" text
    STA !text_to_dma
    LDA #$5E4C             ;below wily's face
    STA !vram_destination   
    JSR DMA_to_VRAM

    ;restore which text to dma so the cycling works
    REP #$20
    LDA #$E000
-:
    STA !text_to_dma
    INC !initial_dma_done
.dma_done
    JMP text_done



.dma_shade:
    LDX !selected_route
    CPX #$02
    BNE .dma_done
    LDA !cursor_pos
    CMP #$02
    BNE .dma_done

    LDA !initial_dma_done
    BNE .dma_done
    REP #$20
    LDA #$E3E2
    STA !text_to_dma      ;shade toggle text 1 
    LDA #$5E55
    STA !vram_destination
    LDA #$0012
    STA !bytes_to_transfer
    JSR DMA_to_VRAM


    REP #$20
    LDA #$E06C             ;"L/R: Swap" text
    STA !text_to_dma
    LDA #$5F75             ;below shade's face
    STA !vram_destination   
    JSR DMA_to_VRAM

    ;restore which text to dma so cycling works
    REP #$20
    LDA #$E3E2
    BRA -


check_buttons:
.check_L:
    REP #$20
    LDA !player_active_pressed
    BIT #$0020
    BEQ .check_R
    LDA !cursor_pos
    CMP #$0001
    BNE .get_shade_visit
    LDA !text_to_dma
    SEC
    SBC #$0012
    STA !text_to_dma
    LDA !new_stage_destination
    DEC
    BPL .store
    LDA #$0005
    BRA .store

.get_shade_visit:
    LDA !shade_visit
    EOR #$0001
    BRA .store_visit



.check_R:
    BIT #$0010
    BEQ .text_done_wrapper
    LDA !cursor_pos
    CMP #$0001
    BNE .get_shade_visit
    LDA !text_to_dma
    CLC
    ADC #$0012
    STA !text_to_dma
    LDA !new_stage_destination
    INC
    CMP #$0006
    BNE .store
    LDA #$0000
    BRL .store

.text_done_wrapper:
    BRL text_done

.get_shade_visit_R
    LDA !shade_visit
    INC
    CMP #$0002
    BNE .store_visit
    LDA #$0000


.store_visit:
    STA !shade_visit
    LDA #$5E55
    STA !vram_destination
    SEP #$20
    LDA #$14
    JSL play_sound_effect
    REP #$20
    LDA #$0016
    EOR !text_to_dma
    BRA ++


.store:
    STA !new_stage_destination
    LDA #$5D2C
    STA !vram_destination
    SEP #$20
    LDA #$14
    JSL play_sound_effect
    REP #$20
    LDA !text_to_dma
    CMP #$E06C
    BCS +
    CMP #$E000
    BCS ++
    LDA #$E05A
    BRA ++

+:
    LDA #$E000
++:
    STA !text_to_dma
    LDA #$0012
    STA !bytes_to_transfer
    JSR DMA_to_VRAM
    BRA text_done


;"fun" part
DMA_to_VRAM:
    REP #$20
    ;LDA #%10000000
    LDA #$0080
    STA $2115
    LDA !vram_destination
    STA $2116           ;vram address
    LDA #$1801          ;two registers, write once
    STA $4330
    LDA.w !text_to_dma  ;text table address
    STA $4332
    LDY.b #$E0          ;text table bank byte
    STY $4334
    LDA !bytes_to_transfer         
    STA $4335
    SEP #$20
    ;LDA.b #%00001000    ;channel 3
    LDA.b #$08          ;channel 3
    STA $420B           ;enable DMA and pray it works OH MY FUCKING GOD JUST WORK
    RTS


;hijacked instructions
text_done:
    SEP #$20
    LDA $04
    STA $1F
    RTL              ;get me the fuck outta here