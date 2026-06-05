.SECTION "Game State Routines"
;================================================================================
; Routines involving the Game State
;================================================================================
;The location of our Current Game State Address must be placed right after our CALL
;The CALL opcode is $CD NN NN, where NN NN is the address we want, which is 1 byte after $CD
;NOTE, we probably need to take BANK SWITCHING into account for this. 
.DEF	GAME_STATE_RAM_ADDRESS		RAM_JumpToCorrectGameState + 1
.DEF    INITIAL_GAME_STATE          InitExample  

;Parameters: HL = New Game State Address
;Returns: None
;Affects: A, HL, GAME_STATE_RAM_ADDRESS
UpdateGameState:
;Point to the address in the CALL opcode in HRAM
	ld a, l
	ld (GAME_STATE_RAM_ADDRESS), a
	ld a, h
	ld (GAME_STATE_RAM_ADDRESS + 1), a

	ret

;--------------------------------
; Initialization of Game State
;--------------------------------
;Only called once at the beginning of the program
GameStateRoutineToRAM:
	ld de, JumpToCorrectGameStateRoutine
    ld hl, RAM_JumpToCorrectGameState
    ; Copy call
    ld a, (de)
    ld (hl), a
    inc hl
    inc de
    ; Copy Address
    ld a, (de)
    ld (hl), a
    inc hl
    inc de
    ld a, (de)
    ld (hl), a
    inc hl
    inc de
    ; Copy return
    ld a, (de)
    ld (hl), a
    inc hl
    inc de

	ret

;This is the initial state that our Game State should be in. NOTE: the Game State will change 
JumpToCorrectGameStateRoutine:
	call INITIAL_GAME_STATE
	ret
JumpToCorrectGameStateRoutineEnd:

DummyGameState:

    nop
    nop
    nop

    ret

.ENDS