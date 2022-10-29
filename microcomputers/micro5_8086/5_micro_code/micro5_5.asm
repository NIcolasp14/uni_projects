;=============================================
;                   MACROS
;=============================================
PRINTCH MACRO CHAR
    PUSH AX
    PUSH DX
    MOV DL,CHAR
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM

PRINTSTR MACRO STRING
    PUSH AX
    PUSH DX
    MOV DX,OFFSET STRING
    MOV AH,9
    INT 21H
    POP DX
    POP AX
ENDM

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

PRINTTAB MACRO
    PUSH AX
    PUSH DX
    MOV DL,9
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM

READCH MACRO
    MOV AH,8
    INT 21H
ENDM

EXIT MACRO
    MOV AX,4C00H
    INT 21H
ENDM
    
    
;=============================================
;                  SEGMENTS
;=============================================    
DATA SEGMENT
        STARTPROMPT DB "START(Y,N):$" 
        ERRORMSG DB "ERROR$" 
ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA


;=============================================
;                    MAIN
;=============================================
MAIN PROC FAR
    MOV AX,DATA
    MOV DS,AX
    PRINTSTR STARTPROMPT   ;Tupwma "START(Y,N):" kai perimenoume eisodo 
    
START: 
    READCH                 ;Diavasma eisodou
    CMP AL,'N' 
    JE FINISH              ;An h eisodos einai N tote exoume termatismo
    CMP AL,'Y' 
    JE CONT                ;An einai Y synexizoume 
    JMP START           
    
CONT:
    PRINTCH AL             ;Typwma Y h N, analogws ti edwse o xrhsths
    PRINTLN
    PRINTLN                   
    
NEWTEMP:
    MOV DX,0
    MOV CX,3               ;Metrhths triwn hex pshfiwn 
    
READTEMP: 
    CALL HEX_KEYB          ;Diavasma eisodou
    CMP AL,'N'             ;Elegxos gia N, alliws -pithanws- exoume hex pshfio
    JE FINISH 
    
;.......Enwsh pshfiwn ston DX.......;
    PUSH CX
    DEC CL                 ;Meiwsh metrhth//analogws thn shmasia theshs pshfiou... 
                           ;...kanoume antistoixa toses olisth_hseis
    ROL CL,2               ;2 aristeres olisth_hseis
    MOV AH,0
    ROL AX,CL              ;Aristeres olisth_hseis, oses o metrhths -> 8 4 0 pshfia
    OR DX,AX               ;Vazoume to pshfio ston arithmo
    POP CX
    LOOP READTEMP
    PRINTTAB
    MOV AX,DX
    CMP AX,2047            ;V<=2 ?
    JBE BRANCH1
    CMP AX,3071            ;V<=3 ?
    JBE BRANCH2
    PRINTSTR ERRORMSG      ;V>3
    PRINTLN
    JMP NEWTEMP 
    
BRANCH1:                   ;1os klados V<=2, T=(800*V) div 4095
    MOV BX,800
    MUL BX
    MOV BX,4095
    DIV BX      
    JMP SHOWTEMP
    
BRANCH2:                   ;2os klados: 2<V<=3, T=((3200*V) div 4095) - 1200
    MOV BX,3200
    MUL BX
    MOV BX,4095
    DIV BX
    SUB AX,1200 
    
SHOWTEMP:
    CALL PRINT_DEC16       ;Akeraio meros (AX)
                           ;Klasmatiko meros = (upoloipo * 10) div 4095
    MOV AX,DX
    MOV BX,10
    MUL BX
    MOV BX,4095
    DIV BX
    PRINTCH ','            ;Ypodiastolh
    ADD AL,48              ;ASCII
    PRINTCH AL             ;Klasmatiko meros
    PRINTLN
    JMP NEWTEMP 
    
FINISH:
PRINTCH AL
EXIT 

MAIN ENDP    


HEX_KEYB PROC NEAR 
READ:
    READCH
    CMP AL,'N'             ;=N ?
    JE RETURN
    CMP AL,48              ;<0 ?
    JL READ
    CMP AL,57              ;>9 ?
    JG LETTER
    PRINTCH AL
    SUB AL,48              ;ASCII
    JMP RETURN
    
LETTER:                    ;A...F
    CMP AL,'A'             ;<A ?
    JL READ
    CMP AL,'F'             ;>F ?
    JG READ
    PRINTCH AL
    SUB AL,55
                           ;ASCII
RETURN:
    RET
HEX_KEYB ENDP   

  
PRINT_DEC16 PROC NEAR     
    PUSH DX
    MOV BX,10              ;Diaireseis me 10 gia decadiko
    MOV CX,0               ;Metrhths pshfiwn
GETDEC:                    ;Eksagwgh pshfiwn
    MOV DX,0               ;Ypoloipo (arithmos mod 10) 
    DIV BX                 ;Diairesh me 10 
    PUSH DX                ;Apothh_hkeush arithmou (proswrinh)
    INC CL
    CMP AX,0               ;An piliko=/=0  ((arithmosdiv10) =/= 0)...
    JNE GETDEC             ;...pame sto GETDEC -> Afairese 10
PRINTDEC:                  ;Emfanish pshfiwn
    POP DX
    ADD DL,48              ;ASCII
    PRINTCH DL
    LOOP PRINTDEC
    POP DX
    RET     
    
PRINT_DEC16 ENDP
CODE ENDS

END MAIN




