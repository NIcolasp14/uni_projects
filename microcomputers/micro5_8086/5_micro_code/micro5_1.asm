;=============================================
;                   MACROS
;=============================================

;Typwnei character
PRINTCH MACRO CHAR
    PUSH AX
    PUSH DX
    MOV DL,CHAR
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM

;Allagh grammhs
PRINTLN MACRO
    PUSH AX
    PUSH DX
    MOV DL,13
    MOV AH,2
    INT 21H
    MOV DL,10
    MOV AH,2
    INT 21H
    POP DX
    POP AX
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
    TABLE DB 128 DUP(?) ;Pinakas dedomenwn
    TWO DB DUP(2)       ;Gia ton elegxo ths isotimias twn arithmwn
DATA ENDS
    
    
CODE SEGMENT
ASSUME CS:CODE, DS:DATA   


;=============================================
;                    MAIN
;=============================================
MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX   
    
;.......Apothikeush arithmwn sthn mnhmh.......
    MOV DI,0            ;Deikths ston pinaka arithmwn
    MOV CX,128          ;Plhthos arithmwn 

STORE:
    MOV TABLE[DI],CL
    INC DI       
    LOOP STORE  
    
;....Elegxos isotimias, arthroish, metrhsh....
    MOV DH,0            ;Gia thn prosthesh AX+DL
    MOV AX,0            ;Athroisma perittwn
    MOV BX,0            ;Plhthos perittwn
    MOV DI,0
    MOV CX,128 
    
ADDODD:
    PUSH AX
    MOV AH,0            ;Gia thn diairesh AX/2
    MOV AL,TABLE[DI]    ;Elegxos isotimias
    DIV TWO          
    CMP AH,0         
    POP AX
    JE SKIPEVEN         ;An o arithmos ston AX einai artios kane skip 
    MOV DL,TABLE[DI]    ;Proswrinh apoth_hkeush
    ADD AX,DX           ;Prosthesh
    INC BX              ;Aukshsh metrhth perittwn  
    
SKIPEVEN:               ;Skip an einai artios
    INC DI
    LOOP ADDODD   
    
;.........Ypologismos kai ektypwsh MO.........
    MOV DX,0           
    DIV BX              ;Diairesh me to plhthos tous
    
    CALL PRINT_NUM8_HEX ;Ektypwsh akeraiou merous phlikou
    PRINTLN 
    
;..............Megisto & Elaxisto.............
    MOV AL,TABLE[0]     ;Arxikopoihsh max
    MOV BL,TABLE[127]   ;Arxikopoihsh min
    MOV DI,0
    MOV CX,128  
    
MAXMIN:
    CMP AL,TABLE[DI]    ;Elegxos parontos stoixeiou
    JC NEWMAX
    JMP MIN  
    
NEWMAX:                 ;An einai megalutero tou max -> new max
    MOV AL,TABLE[DI]
    JMP NEXTNUM   
    
MIN:                    ;Elegxos min
    CMP TABLE[DI],BL
    JC NEWMIN
    JMP NEXTNUM    
    
NEWMIN:                 ;An einai mikrotero tou min -> new min
    MOV BL,TABLE[DI] 
    
NEXTNUM:                ;Epomenos arithmos
    INC DI
    LOOP MAXMIN
    CALL PRINT_NUM8_HEX 
    PRINTCH ' '
    MOV AL,BL
    CALL PRINT_NUM8_HEX 
EXIT   

MAIN ENDP
 
 
;Ektypwsh 8-bit hex arithmou
PRINT_NUM8_HEX PROC NEAR;
    MOV DL,AL
    AND DL,0F0H         ;1o hex
    MOV CL,4
    ROR DL,CL
    CMP DL,0            ;Agnohsh arxikou 0
    JE SKIPZERO
    CALL PRINT_HEX   
SKIPZERO:
    MOV DL,AL    
    AND DL,0FH          ;2o hex - apomonwsh tou ston DL
    CALL PRINT_HEX
    RET  
PRINT_NUM8_HEX ENDP   


;Ektypwsh hex pshfiou apo diafaneies
PRINT_HEX PROC NEAR     ;Ektypwsh periexomenwn DL
CMP DL,9                ;0...9
JG LETTER
ADD DL,48
JMP SHOW
LETTER:
    ADD DL,55           ;A...F   
SHOW:
    PRINTCH DL
    RET      
PRINT_HEX ENDP 


CODE ENDS
END MAIN
