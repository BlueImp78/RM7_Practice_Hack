include


skip_intro:
    LDA #$01
    STA !intro_beaten_flag        
    STA $0B7C                     ;also enable wily
    REP #$20
    LDA #$0101
    STA !8robo_avail_flags        ;enable 8 robots
    STZ $0BB2                     ;hijacked instruction
    SEP #$20
    LDA $39
    STA !selected_route
.done:
    RTL        

stop_title_fadeout:
    SEP #$30
    LDA #$FF
    STA !title_screen_timer
    RTL                     ;don't restore hijacked instruction

upload_title_text:
    LDA !initial_dma_done
    BNE .done
    LDA #$13
    JSL play_music          ;play title screen music we almost never hear
    REP #$20
    LDA #$E07E
    STA !text_to_dma
    LDA #$09A7
    STA !vram_destination   ;below rm7 logo
    LDA #$0364
    STA !bytes_to_transfer
    JSR DMA_to_VRAM
    SEP #$20
    INC !initial_dma_done
    


;hijacked instructions
.done:
    SEP #$20
    STZ $39
    JSL $C1083B 
    RTL

;nuke bg1 vram to have our bg3 text on top of where it would be
nuke_title_bg1_vram:    
    ;REP #$20
    LDA !initial_dma_done
    BEQ .done
    LDA !bg1_nuke_done
    BNE .done    
    REP #$20
    LDA #$E800
    STA !text_to_dma
    LDA #$522C
    STA !vram_destination   
    LDA #$0550
    STA !bytes_to_transfer
    JSR DMA_to_VRAM
    SEP #$20
    INC !bg1_nuke_done

;hijacked instructions
 .done:
    SEP #$20
    INC $00D1
    LDX #$00
    RTL
