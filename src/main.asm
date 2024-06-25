hirom

org $008000    
	incsrc defines.asm
	incsrc hijacks.asm

org freerom
	incsrc title_screen.asm
	incsrc stage_select.asm
	incsrc stage.asm
	incsrc room_timer.asm
	incsrc menu.asm

warnpc freerom|$FFFF


org $E0E000
	incsrc text_table.asm



warnpc freerom|$FFFF