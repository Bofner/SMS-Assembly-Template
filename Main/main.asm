; ==============================================================
;  WLA-DX banking setup
; ==============================================================

; Memory Map
;      $FFFF -----------------------------------------------------------
;            Paging registers
;      $FFFC -----------------------------------------------------------
;            Mirror of RAM at $C000-$DFFF
;      $E000 -----------------------------------------------------------
;            8k of on-board RAM (mirrored at $E000-$FFFF)
;      $C000 -----------------------------------------------------------
;            16k ROM Page 2, or one of two pages of Cartridge RAM
;      $8000 -----------------------------------------------------------
;            16k ROM Page 1
;      $4000 -----------------------------------------------------------
;            15k ROM Page 0
;      $0400 -----------------------------------------------------------
;            First 1k of ROM Bank 0, never paged out with rest of Page 0
;      $0000 -----------------------------------------------------------

; For Projects bigger than 32k
/* .MEMORYMAP	
    SLOTSIZE $7FF0	
    SLOT 0 $0000	
    SLOTSIZE $10	
    SLOT 1 $7FF0	
    SLOTSIZE $4000	
    SLOT 2 $8000	
    DEFAULTSLOT 2	
.ENDME	 
.ROMBANKMAP	
    BANKSTOTAL 4	
    BANKSIZE $7FF0	
    BANKS 1	
    BANKSIZE $10	
    BANKS 1	
    BANKSIZE $4000	
    BANKS 2	
.ENDRO	 */

; For 32k Projects
 .MEMORYMAP	
    SLOTSIZE $4000	
    SLOT 0 $0000	
    SLOT 1 $4000	
    SLOT 2 $8000
    DEFAULTSLOT 2	
.ENDME	 
.ROMBANKMAP	
    BANKSTOTAL 2	
    BANKSIZE $4000	
    BANKS 2	
.ENDRO	


; ==============================================================
;  SMS defines
; ==============================================================

; Hardware constants
.DEFINE     PORT_VDP_ADDRESS        $BF 
.DEFINE     VDP_DATA                $BE
.DEFINE     VRAM_WRITE              $4000
.DEFINE     VRAM_READ               $0000
.DEFINE     CRAM_WRITE              $C000
.DEFINE     SAT_ADDRESS             $3800

; System variants
.DEFINE     SG_HARDWARE             $01
.DEFINE     SC_HARDWARE             $03
.DEFINE     SMS_HARDWARE            $08

; Graphics constants
.DEFINE     PALETTE_SIZE            $10

; Screen constants
.DEFINE     UP_BOUNDS               $02
.DEFINE     DOWN_BOUNDS             $BD
.DEFINE     LEFT_BOUNDS             $05
.DEFINE     RIGHT_BOUNDS            $FD


; ==============================================================
;  SDSC tag and ROM header
; ==============================================================

.SDSCTAG 0.1, "SMS Hello World", "Hope this helps ya","Bofner"

.BANK 0 slot 0
.ORG $0000
; ==============================================================
;  Boot Section
; ==============================================================

    di                  ; Disable interrupts
    im 1                ; Interrupt mode 1
    jp TEMPLATE_Init    ; Jump to the initialization program

; ==============================================================
;  Interrupt Handlers Section
; ==============================================================

; Interrupts
.BANK 0 SLOT 0
.ORG $0038
	jp InterruptHandler

; NMI (Pause)
.BANK 0 SLOT 0
.ORG $0066
    jp PauseHandler

.INCLUDE "../FixedBank/interruptHandlers.asm"

; ==============================================================
;  Include our STRUCTS so we can create them in MAIN
; ==============================================================
.INCLUDE "structs.asm"


; ==============================================================
;  Boiler Variables 
; ============================================================== 
.ENUM $C000 export
    ; SATBuffer
    VBuffer                     dsb $40 ; Holds the yPos for all sprites
    HCBuffer                    dsb $80 ; Holds the xPos and CC for all sprites

    systemHardware              db      ; Are we running SMS or an SG-1000 variant?

    VDPStatus                   db      ; Holds VDP Status from the interrupt
                                        ; Bit 7:     1 = VBlank
                                        ; Bit 6:     1 = >=9 sprites on raster
                                        ; Bit 5:     1 = Sprite collision
                                        ; Bit 4-0:   No function

; Player 1 Controller
    DCInput                     db      ; $DC input
    DDInput                     db      ; $DD input
; CURRENTLY CONFIGED FOR GB
	; %DULR(ST)(SEL)BA
	previousKeyPress1	        db		; The previous state of key presses for player 1
	currentKeyPress1	        db		; The current state of key presses for player 1
	newKeyPress1		        db		; The most recent state of key presses for player 1
; Player 2 Controller	
	previousKeyPress2	        db		; The previous state of key presses for player 2
	currentKeyPress2	        db		; The current state of key presses for player 2
	newKeyPress2		        db		; The most recent state of key presses for player 2

; Background 
; Any special parallax screen scrolling will be declared within the level file
	nextHBlankStep  	        dw      ; Variable that tells where to go for next HBlank
	frameFinish			        db		; $00 = NO_FINISH, 
                                        ; $01 = WRITE_FINISH, 
                                        ; $11 = VBLANK_FINISH
	frameCount     		        db      ; Used to count frames in intervals of 60	
	targetBGPal                 instanceof paletteStruct		
                                        ; Target BG palette for a fade in
    currentBGPal		        instanceof paletteStruct		
                                        ; Current BG palette for a fade in
    targetSPRPal		        instanceof paletteStruct		
                                        ; Target SPR palette for a fade in
    currentSPRPal		        instanceof paletteStruct		
                                        ; Current SPR palette for a fade in

; Game State
    RAM_JumpToCorrectGameState  dsb $04 ; Address is RAM that is used to 
                                        ; call ${currentGameState}
                                        ; ret
    changeGameStateFlag         db      ; Do we need to change Game state?
    sceneComplete               db      ; Is the current scene finished?

    ; $C000 to $DFFF is the space I have to work with for variables and such
    endByte                     db      ; The first byte post boiler-plate data
    
.ENDE

; ==============================================================
;  Game Constants
; ==============================================================



; =============================================================================
;  Special numbers 
; =============================================================================

.DEFINE postBoiler  endByte     ; Location in memory that is past the boiler plate 


; ==============================================================
;  Start up/Initialization
; ==============================================================

; Initialization parameters for the 11 registers on SMS
VDPInitDataSMS:
    .db %00010110       ; reg. 0
                        ; Vertical Scroll Inhibit
                        ; Horizontal Scroll Inhibit
                        ; Left Column Blank
                        ; Enable Interrupts
                        ; Sprite Shift
                        ; Always 1
                        ; Always 1 
                        ; External Sync (Always 0)
    .db %10100000       ; reg. 1
                        ; Always set to 1
                        ; Enable display
                        ; VBlank interrupts
                        ; 224 line mode
                        ; 240 line mode
                        ; Mega Drive mode 5 enable
                        ; 8x16 Sprites
                        ; Low Res, 16x16 Sprites 
    .db $FF             ; reg. 2, Name table at $3800
    .db $FF             ; reg. 3 Always set to $FF
    .db $FF             ; reg. 4 Always set to $FF
    .db $FF             ; reg. 5 Address for SAT, 
                        ; $FF = SAT at $3F00 
    .db $FF             ; reg. 6 Base address for sprite patterns
    .db $F0             ; reg. 7 Overrscan Color at Sprite Palette 1  
    .db $00             ; reg. 8 Horizontal Scroll
    .db $00             ; reg. 9 Vertical Scroll
    .db $FF             ; reg. 10 Raster line interrupt off 
VDPInitDataSMSEnd:

.SECTION "Outer Framework"
TEMPLATE_Init: 
    ld sp, $DFF0



; ==============================================================
;  Set up VDP Registers
; ==============================================================
    @Registers::
        ld hl,VDPInitDataSMS                        ;  Point to register init data.
        ld b,VDPInitDataSMSEnd - VDPInitDataSMS     ;  8 bytes of register data.
        ld c, $80                                   ;  VDP register command byte.                      
        call SetVDPRegisters
    

; ==============================================================
;  Clear VRAM
; ==============================================================
    @ClearVRAM:
    ; Set VRAM to all be $00
        call ClearVRAM

; ==============================================================
;  Setup general sprite variables
; ==============================================================
    @Variables:
    ; Start frameCount at zero
        xor a
        ld hl, frameCount
        ld (hl), a


; ==============================================================
;  Setup Game State
; ==============================================================
    @GameState:
        call GameStateRoutineToRAM

; ==============================================================
;  Game sequence
; ==============================================================
    @Interrupts:
        ei

MainLoop:
    halt
    call RAM_JumpToCorrectGameState
    jr MainLoop

.ENDS

; ==============================================================
;  Include Game Mechanic Files
; ==============================================================
.INCLUDE "../FixedBank/vdpHandlers.asm"
.INCLUDE "../FixedBank/bankSwitchAndGameState.asm"
.INCLUDE "../ExampleScreen/exampleScreen.asm"





