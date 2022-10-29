;=============================================
;                   MACROS
;=============================================
    
    
;Typwnei character
PRINTCHAR MACRO CHAR
  PUSH AX
  PUSH DX
  MOV DL,CHAR
  MOV AH,2
  INT 21H
  POP DX
  POP AX
ENDM
 
;Typwnei string
PRINTSTR MACRO STRING
  PUSH AX
  PUSH DX
  MOV DX,OFFSET STRING
  MOV AH,9
  INT 21H
  POP DX
  POP AX
ENDM  

;Allagh grammhs
PRINTLN MACRO
  PUSH AX
  PUSH DX
  MOV DL,0AH
  MOV AH,2
  INT 21H
  MOV DL,0DH
  MOV AH,2
  INT 21H
  POP DX
  POP AX
ENDM
 
;Diavasma character
READCHAR MACRO
  MOV AH,8
  INT 21H
ENDM 

;Exit
EXIT MACRO
  MOV AX,4C00H
  INT 21H
ENDM
 
   
;=============================================
;                  SEGMENTS
;=============================================
DATA SEGMENT
    PRINTZ DB 'Z=$'      ;Typwnei 'Z=' kai perimenei eisodo
    PRINTW DB 'W=$'      ;Typwnei 'W=' kai perimenei eisodo
    PRINTSUM DB 'Z+W=$'  ;Typwnei 'Z+W=' kai typwnei to apotelesma
                         ;me vash tis parapanw eisodous
    PRINTDIFF DB 'Z-W=$' ;Typwnei 'Z-W=' kai typwnei to apotelesma
                         ;me vash tis parapanw eisodous
    Z DB 0
    W DB 0
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA  
	
          
;=============================================
;                   MAIN
;=============================================
MAIN PROC FAR
		MOV AX,DATA
		MOV DS,AX

	START:
		PRINTSTR PRINTZ
		CALL READDIG	        ;Diavase to prwto pshfio tou Z
        MOV BL, 10
	    MUL BL
		LEA DI,Z                ;Swse to
		MOV [DI],AL
	    CALL READDIG	        ;Diavase to deutero pshfio tou Z
		ADD [DI],AL             ;Swse to

		PRINTCHAR ' '           ;Typwnei keno metaksh twn 'Z=$' kai 'W=$'

		PRINTSTR PRINTW
	    CALL READDIG	        ;Diavase to prwto pshfio touf W
        MOV BL, 10
	    MUL BL
	    LEA DI,W                ;Swse to
		MOV [DI],AL
		CALL READDIG            ;Diavase to deutero pshfio tou W
		ADD [DI],AL             ;Swse to

		PRINTLN

	    MOV AL,[DI]             ;      W
		LEA DI,Z                ;      Z
		ADD AL,[DI]             ;Ypologismos athroismatos
		
		PRINTSTR PRINTSUM
		CALL PRINT_8BIT_HEX	    ;Typwse to apotelesma

		PRINTCHAR ' '

		MOV AL,[DI]			    ;      Z
		LEA DI,W			    ;      W
		MOV BL,[DI]

        PRINTSTR PRINTDIFF
		CMP AL,BL		  	    ;Sygkrish Z me W... 
		JB NEG                  ;...gia na doume an to apotelesma 
		                        ;einai arnhtiko h thetiko
		SUB AL,BL			    ;An Z>W
		JMP PRINTSUB  
		
	NEG:
		SUB BL,AL			    ;An Z<W
		MOV AL,BL
        PRINTCHAR '-' 
        
	PRINTSUB:
			CALL PRINT_8BIT_HEX	;Typwse to apotelesma
			PRINTLN
			PRINTLN
			JMP START
MAIN ENDP
  
  
;..Diavase-typwse-apoth_hkeuse ena decadiko pshfio ston AL..
READDIG PROC NEAR
	READ:
			READCHAR
			CMP AL,48
			JB READ
			CMP AL,57			;Diavaze thn eisodo mexri na 
			                    ;einai metaksu 0 kai 9
			JA READ
			PRINTCHAR AL
			SUB AL,48			;Kwdikas ASCII 
			RET
READDIG ENDP
 
 
;..........Print 8-bit number in HEX (saved in AL)..........
PRINT_8BIT_HEX PROC NEAR
			MOV DL,AL
			AND DL,0F0H			;Apomonwse to prwto hex pshfio
			MOV CL,4
			ROR DL,CL
			CMP DL,0			;An einai 0, mhn to typwseis
			JE ZERO
			CALL PRINT_HEX
	ZERO:
			MOV DL,AL
			AND DL,0FH			;Apomonwse to deutero hex pshfio
			CALL PRINT_HEX
			RET
PRINT_8BIT_HEX ENDP
            
            
;...............Print HEX digit (saved in DL)................
PRINT_HEX PROC NEAR
			CMP DL,9			;An o arithmos einai metaksy twn 0 kai 9,
			                    ;prosthese 30 hex
			JG ADDR1
			ADD DL,30H
			JMP ADDR2
	ADDR1:
			ADD DL,37H			;Alliws an o arithmos einai metaksu twn A kai F,
			                    ;prosthese 37 hex
	ADDR2:
			PRINTCHAR DL
			RET
PRINT_HEX ENDP


CODE ENDS
END MAIN




