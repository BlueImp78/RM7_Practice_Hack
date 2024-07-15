include

room_timer:
        JSL $C1023D     ;hijacked instruction
        SEP #$20
        LDA !timer_draw_flag
        BNE .store_timer  
+: 
        LDA !timer_clear_flag
        BEQ ++
        JSR clear_timer_vram
        BRA .done
++:
        JSR check_turbo_or_spring_boss_room
        BCS +++
        LDA $0BC6
        BNE .done           ;dont run timer when no player control
+++:
        STZ !timer_control
        REP #$20
        LDA !timer_seconds
        XBA
        CMP #$633B
        BCS .done           ;if timer would go past 99'59, stop increasing it
        SEP #$20
        LDA !timer_ms
        CMP #$3B
        BNE .increase_ms
        INC !timer_seconds
        STZ !timer_ms
        BRA .done

.store_timer:
        LDA !timer_control
        BNE .done
        INC !timer_control

        LDA !timer_seconds
        JSR hex_to_decimal
        STA !display_timer_seconds

        LDA !timer_ms
        JSR hex_to_decimal
        STA !display_timer_ms

        STZ !timer_seconds
        STZ !timer_ms
        STZ !timer_draw_flag
        STZ !timer_control
        INC !timer_onscreen_flag
        JSR dma_timer
        BRA .done

.increase_ms
        INC !timer_ms
.done:

        REP #$20
        RTL     


check_turbo_or_spring_boss_room:
        LDA !stage_destination
        CMP #$04
        BEQ .turbo
        LDA !selected_route
        CMP #$02
        BNE .done
        LDA !stage_destination
        CMP #$08
        BNE .done
        LDA !room_number
        CMP #$09
        BEQ .is_boss_room
        BRA .done

.turbo:
        LDA !room_number
        CMP #$08
        BEQ .is_boss_room
.done:
        CLC
        RTS

.is_boss_room:
        SEC
        RTS


hex_to_decimal:
        STA !temp_200       
        LSR A
        ADC !temp_200
        ROR A
        LSR A
        LSR A
        ADC !temp_200
        ROR A
        ADC !temp_200
        ROR A
        LSR A
        AND #$3C
        STA !temp_201        
        LSR A 
        ADC !temp_201
        ADC !temp_200
        RTS


dma_timer:
.get_seconds:
        REP #$20
        LDA !display_timer_seconds
        BEQ .done
        SEP #$20
        AND #$F0
        LSR A
        LSR A
        LSR A
        LSR A      
        STA !timer_digit_1
        LDA !display_timer_seconds
        AND #$0F
        STA !timer_digit_2

.get_frames:
        LDA !display_timer_ms
        AND #$F0
        LSR A
        LSR A
        LSR A
        LSR A  
        STA !timer_digit_3
        LDA !display_timer_ms
        AND #$0F
        STA !timer_digit_4

.set_vram:
        REP #$20
        LDA #$E406
        STA !text_to_dma
        LDA #$0838
        STA !vram_destination
        LDA #$0002
        STA !bytes_to_transfer

        SEP #$20

        ;if in wily 4 turbo or shade room, dma timer with fblank (im losing my shit)
        LDA !stage_destination
        CMP #$0D
        BNE .no_fblank
        LDA !room_number
        CMP #$05
        BEQ .fblank
        CMP #$07
        BNE .no_fblank
.fblank:
        LDA #$80
        STA $2100
.no_fblank:
        LDA !timer_digit_1
        JSR dma_timer_digit
        LDA !timer_digit_2
        JSR dma_timer_digit
        
        LDA #$1A
        STA !text_to_dma
        JSR draw_quote

        LDA !timer_digit_3
        JSR dma_timer_digit
        LDA !timer_digit_4
        JSR dma_timer_digit
.done:
        RTS


 dma_timer_digit:
        ASL A
        REP #$20
        BNE +
        LDA #$E406
        BRA ++
+:
        CLC
        ADC #$E406
++:
        STA !text_to_dma
draw_quote:
        JSR DMA_to_VRAM
        INC !vram_destination
        RTS


set_timer_flag_transition:
        LDA !stage_destination
        CMP #$06                ;check if shade stage
        BNE set_timer_flag
        LDA !room_number
        CMP #$02                ;check if pumpkin door room
        BNE set_timer_flag
        INC $0BC0               ;hijacked instruction
        INC $0BC1               ;hijacked instruction 
        RTL  


set_timer_flag:
        INC !timer_draw_flag
        INC $0BC0               ;hijacked instruction
        INC $0BC1               ;hijacked instruction
        RTL


set_timer_flag_door:
        JMP set_timer_flag


set_timer_flag_teleporter:
        INC !timer_draw_flag
        JSL $C30941             ;hijacked instruction
        RTL


boss_death_draw_timer:
        INC !timer_draw_flag
        JSL $C03CBB             ;hijacked instruction
        RTL


set_timer_flag_machine_death:
        INC !timer_draw_flag
        JSL $C1083B             ;hijacked instruction
        RTL


set_timer_flag_capsule_death:
        INC !timer_draw_flag
        JSL $C03C59             ;hijacked instruction
        RTL


wily1_bass_death_draw_timer:
        LDA !stage_destination
        CMP #$0D                ;check if wily4
        BNE +
        LDA !room_number
        CMP #$09                ;clear and reset timer instead once capsule fight starts
        BEQ .clear
+:
        LDA $0BCA
        BNE .done
        LDA $0B7F               ;dont draw timer when riding boss rush elevator
        BEQ .done
        INC !timer_draw_flag
.done:
        INC $0BC6               ;hijacked instruction
        LDA $0C02               ;hijacked instruction
        RTL

.clear:
        LDA $0BCA
        BNE .done
        INC !timer_clear_flag
        STZ !timer_seconds
        STZ !timer_ms
        BRA .done



wily1_bass_death_clear_timer:
        INC !timer_clear_flag
        STZ $0BC6               ;hijacked instruction
        STZ $0C53               ;hijacked instruction
        RTL        


;TODO: change label, this is called in a bunch of other spots and not just wily 1
wily1_post_bass_clear_timer:
        LDA !stage_destination
        CMP #$0B
        BEQ .done               ;dont immediately clear timer upon bass 2 death (ty capcom)
        CMP #$0A
        BEQ .wily1
        CMP #$0D
        BEQ .wily4     
        CMP #$06
        BEQ .shade         
        JSR check_turbo_or_spring_boss_room
        BCS .done 
-:
        INC !timer_clear_flag
.done:
        LDA $52                 ;hijacked instruction
        STA $6A
        RTL

.wily1:
        LDA !room_number
        CMP #$05 
        BEQ .bass1_room               
        CMP #$06                ;return if in room 6 (otherwise it draws on ammo/health pickup, ty capcom)
        BEQ .done
        BRA -

.bass1_room:
        LDA $0BC6
        BEQ -                   ;if in bass room, make sure it only draws once (IM LOSING MY MIND)
        BRA .done


.wily4:
        LDA !room_number
        BEQ .done               ;dont immediately clear timer in wily 4 teleporters (ty capcom)
        CMP #$09
        BEQ .done               ;dont clear if in capsule ending sequence
        LDA $0BC6               
        BEQ -
        CMP #$03                ;but clear it once we lose control inside refight rooms
        BNE .done 
        BRA -

.shade:
        LDA !selected_route
        CMP #$02 
        BNE -
        LDA !room_number
        CMP #$0E
        BEQ .done               ;don't clear it on protoman death
        BRA -


fortress_boss_death_draw_timer:
        INC !timer_draw_flag
        INC $0BC6               ;hijacked instruction
        LDA #$60                ;hijacked instruction
        RTL


screen_transition_finish_clear_timer:
        INC !timer_clear_flag
        DEC $0BBF               ;hijacked instruction
        DEC $0BC0               ;hijacked instruction
        RTL


screen_transition_finish_right_clear_timer:
        INC !timer_clear_flag
        STZ $0BBF               ;hijacked instruction
        STZ $0BC0               ;hijacked instruction
        RTL
        

clear_timer_vram:
        REP #$20
        LDA #$E800
        STA !text_to_dma
        LDA #$0838
        STA !vram_destination
        LDA #$000A
        STA !bytes_to_transfer
        JSR DMA_to_VRAM
        SEP #$20
        STZ !timer_clear_flag
        STZ !timer_onscreen_flag
        RTS
        