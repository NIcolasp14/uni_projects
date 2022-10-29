;=============================================
;                   MACROS
;=============================================


READ MACRO                    
    MOV AH, 08H 
    INT 21H
ENDM

PRINT MACRO CHAR
    MOV DL, CHAR
    MOV AH, 02H
    INT 21H
ENDM

PRINT_STR MACRO STRING
    MOV DX, OFFSET STRING 
    MOV AH, 09H
    INT 21H
ENDM

EXIT MACRO
    MOV AX, 4C00H
    INT 21H
ENDM
    
    
;=============================================
;                   MAIN
;=============================================    
START:                        
	MOV CX, 3                 ; Arxikopoihsh metrhth se 3 gia ta 3 hex psifia	                          
	MOV BX, 0000H             ; BX = 0000000000000000
	                          ; Ston opoio tha ginei apoth_hkeush tou pshfiou eisodou
	                                                   
INPUT:                       
	CALL HEX_KEYB             ; Diavasma hex pshfiou h termatikou kai apoth_hkeush ston AL
	CMP AL, 'T'               ; An einai to termatiko 'T'...
	JE QUIT                   ; ...to programma teleiwnei
	OR BX, AX                 ; Alliws apoth_hkeush tou hex artihmou ston BX 
	SHL BX, 1                 ; 4 aristeres olisth_hseis
	SHL BX, 1                 ; oses osa ta binary bits enos hex psifiou 
	SHL BX, 1                
	SHL BX, 1                 
	LOOP INPUT                ; Diavasma eisodou mexri to periexomeno tou CX na ginei 0

OUTPUT:                       
	MOV CL, 4                 ; 4 dekdies olisth+_hseis tou BX...
	SHR BX, CL                ; ...giati olisth_hsame thn eisodo 4 fores aristera
	CALL PRINT_HEX            ; Typwnei ton isodynamo hex arithmo
    PRINT "="
    CALL PRINT_DEC            ; Typwnei ton isodynamo dec arithno
    PRINT "="
    CALL PRINT_OCT            ; Typwnei ton isodynamo oct arithmo
    PRINT "="
    CALL PRINT_BIN            ; Typwnei ton isodynamo bin arithmo
    MOV DX, 0AH               ; Nea grammh
    MOV AH, 02H
    INT 21H
    MOV DX, 0DH
    MOV AH, 02H
    INT 21H
	JMP START                 ; Epanalaves

QUIT:
	EXIT                      ; Telos programmatos

HEX_KEYB PROC NEAR            ; Yporoutina pou diavazei egkyro hex pshfio apo thn eisodo... 
                              ; ...kai ton apoth_hkeuei AL
	IGNORE:                   
		READ                  ; Diavasma eisodou kai apoth_hkeush ASCII timhs ston AL
		MOV AH, 00H           ; AH = 00000000
		CMP AL, 'T'           ; Elegxos gia termatiko symvolo
		JE FINISH             ; An vrethei, h yporoytina termatizei
		CMP AL, 30H           ; An timh ASCII <30 hex mh egkyro hex pshfio...
		JL IGNORE             ; ...diavase ksana thn eisodo
		CMP AL, 39H           ; An timh ASCII metaksu 30 hex and 39 hex [kleisto synolo] 
		JBE FOO_1             ; tote to pshfio einai egkyro
		CMP AL, 40H           ; An timh ASCII 40 hex, den eimai egkyro...
		JE IGNORE             ; ...kai diavazoume ksana
		CMP AL, 46H           ; An timh ASCII megalyterh apo 46H
		JA IGNORE             ; tote to pshfio den einai egkyro...
		                      ; ...kai diavazoume ksana
		SUB AL, 31H           ; AN timh ASCII metaksy 41 hex kai 46 hex [kleisto synolo]
		SUB AL, 06H           ; tote to pshfio einai ena apo ta: A, B, C, D, E, F
		                      ; Afairoume 31 hex apo thn ASCII timh...
		                      ; ...kai 6 hex gia dekadiko apotelesma
		JMP FINISH
		            
    FOO_1:
		SUB AL, 30H           ; Pshfio metaksy 0 and 9 [kleisto synolo]
		                      ; Afairw 30 hex apo thn ASCII timh
	FINISH:
		RET                  
HEX_KEYB ENDP
         
; Typwnei 12-bit hex arithmo         
PRINT_HEX PROC NEAR           
    PUSH BX
    PUSH CX
    PUSH DX
    
    MOV DX, BX
    AND DX, 0F00H             ; Apomonwsh shmantikou hex pshfiou
    CMP DH, 09H               ; Evresh ASCII timhs 
    JBE ADDR1
    ADD DH, 0031H
    ADD DH, 06H
    JMP ADDR2
    ADDR1:
        ADD DH, 0030H
    ADDR2:
        PRINT DH
    
    MOV CX, 4    
    MOV DX, BX
    AND DX, 00F0H             ; Apomonvsh deuterou pio shmantikou pshfiou tou hex
    SHL DX, CL                ; Evresh ASCII timhs
    CMP DH, 09H
    JBE ADDR3
    ADD DH, 0031H
    ADD DH, 06H
    JMP ADDR4
    ADDR3:
        ADD DH, 0030H
    ADDR4:
        PRINT DH
        
    MOV DX, BX
    AND DX, 000FH             ; Apomonwsh tritou kai ligoterou shmantikou hex pshfiou
    CMP DL, 09H               ; Evresh ASCII timhs
    JBE ADDR5
    ADD DL, 0031H
    ADD DL, 06H
    JMP ADDR6
    ADDR5:
        ADD DL, 0030H
    ADDR6:
        PRINT DL
           
    POP DX
    POP CX
    POP BX
    RET    
PRINT_HEX ENDP
                 
                 
; Typwnei 12-bit dec arithmo
PRINT_DEC PROC NEAR           
    PUSH BX
    PUSH CX
    
    MOV DX, BX
        
    MOV CX, 00FFH
     
; Xiliades
    FOR1:                     
        INC CX
        SUB DX, 03E8H
        CMP DX, 0000H
        JGE FOR1
    ADD DX, 03E8H
    
    PUSH DX
    ADD CL, 30H               ; ASCII              
    PRINT CL                  ; Typwnei xiliades
    POP DX
    
    MOV CX, 00FFH
      
; Ekatontades
    FOR2:                     
        INC CX
        SUB DX, 0064H
        CMP DX, 0000H
        JGE FOR2
    ADD DX, 0064H
    
    PUSH DX                   ; ASCII
    ADD CL, 30H               ; Typwnei ekatontades
    PRINT CL
    POP DX
    
    MOV CX, 00FFH 
    
; Decades
    FOR3:                    
        INC CX
        SUB DX, 000AH
        CMP DX, 0000H
        JGE FOR3
    ADD DX, 000AH
    
    PUSH DX
    ADD CL, 30H               ; ASCII
    PRINT CL                  ; Typwnei decades
    POP DX 
       
; Monades    
    PUSH DX
    ADD DL, 30H               ; ASCII
    PRINT DL                  ; Typwnei monades
    POP DX   
    
    POP CX
    POP BX
    RET    
PRINT_DEC ENDP
             
; Typwnei 12-bit oct arithmo           
PRINT_OCT PROC NEAR            
    PUSH BX
    PUSH AX
    PUSH DX
    
    MOV DX, BX                ; Apomonwsh shmantikoterou oct pshfiou                                          
    AND DH, 0EH               ; Evresh ASCII timhs
    SHR DH, 1                 
    ADD DH, 30H               
    PRINT DH
    
    MOV DX, BX
    MOV CL, 2
    AND DX, 01C0H             ; Apomonwsh deuterou shmantikoterou oct pshfiou     
    SHL DX, CL                ; Evresh ASCII timhs
    ADD DH, 30H               
    PRINT DH                  
    
    MOV DX, BX
    MOV CL, 3
    AND DL, 38H               ; Apomonwsh tritou shmantikoterou oct pshfio
    SHR DL, CL                ; Evresh ASCII timhs
    ADD DL, 30H              
    PRINT DL                  
    
    MOV DX, BX
    AND DL, 07H               ;  Apomonwsh tetartou kai ligoterou shmantikou oct pshfio
    ADD DL, 30H               ; Evresh ASCII timhs
    PRINT DL                 
    
    POP DX    
    POP AX
    POP BX
    RET    
PRINT_OCT ENDP
        
; Typwnei 12-bit bin arithmo        
PRINT_BIN PROC NEAR           
    
    PUSH BX
    PUSH AX 
        
    MOV CL, 4
    SHL BX, CL
        
    MOV CX, 12                ; CX metrhths gia ta 12 bits
    
    FOO:                      ; Elegxos twn 12 bits
                              ; An bit = 0, tote ASCII: 30 hex // An bit = 1, tote ASCII: 31 hex
        RCL BX, 1             ; Mia aristerh olisth_hsh, symperilamvanomenou kratoumenou
        JC L 
        MOV AL, 30H
        JMP CONT
        L:
            MOV AL, 31H
        CONT:
            PRINT AL
            LOOP FOO          ; Epanalave mexri na mhdenistei o metrhths
    
    POP AX    
    POP BX    
    RET
PRINT_BIN ENDP

RET                          


