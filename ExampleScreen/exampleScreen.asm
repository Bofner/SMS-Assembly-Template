; ============================================================================================
;  Example Graphics Screen
; ============================================================================================

InitExample:
    di
; ==============================================================
;  Scene beginning
; ==============================================================
    ld hl, sceneComplete
    ld (hl), $00

    inc hl                                  ; ld hl, sceneID
    ld (hl), $00


; ==============================================================
;  Clear Video RAM
; ==============================================================
    @ClearData:
    ; Reset VRAM and SAT
        call ClearVRAM
        call ClearSATBuff
    ; Reset scroll values
        xor a
        out (PORT_VDP_ADDRESS), a
        ld a, $88
        out (PORT_VDP_ADDRESS), a		; Set BG X-Scroll to 0

        xor a
        out (PORT_VDP_ADDRESS), a
        ld a, $89
        out (PORT_VDP_ADDRESS), a		; Set BG Y-Scroll to 0


; ==============================================================
;  Load Example Palettes
; ==============================================================
    @Palette:
    ; Write current BG palette to currentPalette struct
        ld hl, currentBGPal.color0
        ld de, ExampleBGPalette
        ld b, $10
        call PalBufferWrite

    ; Write current SPR palette to currentPalette struct
        ld hl, currentSPRPal.color0
        ld de, FadedPalette
        ld b, $10
        call PalBufferWrite

    ; Write target BG palette to targetPalette struct
        ld hl, targetBGPal.color0
        ld de, ExampleBGPalette
        ld b, $10
        call PalBufferWrite

    ; Write target SPR palette to targetPalette struct
        ld hl, targetSPRPal.color0
        ld de, FadedPalette
        ld b, $10
        call PalBufferWrite

    ; Actually update the palettes in VRAM
        call LoadBackgroundPalette
        call LoadSpritePalette

; ==============================================================
;  Load Example Tiles
; ==============================================================
    @VideoRAM:
    ; Load Example Screen Tiles
        ld hl, $0000 | VRAM_WRITE
        call SetVDPAddress
        ld hl, ExampleTiles
        ld bc, ExampleTilesEnd-ExampleTiles
        call CopyToVDP
        
    ; Load Map
        ld hl, $3800 | VRAM_WRITE
        call SetVDPAddress
        ld hl, ExampleMap
        ld bc, ExampleMapEnd-ExampleMap
        call CopyToVDP


; ==============================================================
;  Memory (Structures, Variables & Constants) 
; ==============================================================
    @Sprites:


; ==============================================================
;  Set up screen
; ==============================================================
    @UpdateGameState:
    ; Update Game State
        ld hl, MainLoopExample
        call UpdateGameState
    ; Turn on screen 
        ld a, %11100000 ; reg. 1
                        ; Always set to 1
                        ; Enable display
                        ; VBlank interrupts
                        ; 224 line mode
                        ; 240 line mode
                        ; Mega Drive mode 5 enable
                        ; 8x16 Sprites
                        ; Low Res, 16x16 Sprites 
        ld c, $81
        call UpdateVDPRegister
    ; Turn on Screen
        ei

MainLoopExample:
    nop
    nop
    nop

    ret





; ========================================================
;  Background
; ========================================================
; ----------------
;  BG Maps
; ----------------
ExampleMap:
    .INCLUDE "../Assets/ExampleScreen/Backgrounds/SteelfingerStudiosSMSMap.inc"
ExampleMapEnd:
; ----------------
;  BG Palettes
; ----------------
ExampleBGPalette:
    .INCLUDE "../Assets/ExampleScreen/Backgrounds/SteelfingerStudiosSMSPal.inc"
ExampleBGPaletteEnd:
; ----------------
;  BG Tiles
; ----------------
ExampleTiles:
    .INCLUDE "../Assets/ExampleScreen/Backgrounds/SteelfingerStudiosSMSTiles.inc"
ExampleTilesEnd:


; ========================================================
;  Sprites
; ========================================================
