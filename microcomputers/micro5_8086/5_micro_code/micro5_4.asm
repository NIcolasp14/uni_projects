;=============================================
;                   MACROS
;=============================================
PRINT MACRO CHAR        
    PUSH AX
    PUSH DX 
    MOV DL,CHAR
    MOV AH,2
    INT 21H
    POP DX
    POP AX
ENDM PRINT    
      
           
EXIT MACRO               
    MOV AX,4C00H
    INT 21H
ENDM EXIT
  
  
PRNT_STR MACRO STRING    
    MOV DX,OFFSET STRING
    MOV AH,9
    INT 21H
ENDM PRNT_STR 

                     
READ MACRO               
    MOV AH,8
    INT 21H
ENDM READ
       
       
;=============================================
;                  SEGMENTS
;=============================================
DATA_SEG    SEGMENT
    SYMBOLS DB 20 DUP(?)
    NEWLINE DB 0AH,0DH,'$'          
DATA_SEG    ENDS

CODE_SEG    SEGMENT
    ASSUME CS:CODE_SEG, DS:DATA_SEG
    

;=============================================
;                    MAIN
;=============================================
MAIN PROC FAR  
    
    MOV AX,DATA_SEG
    MOV DS,AX
  
START:    
    MOV CX,20            ;Arxikopoihsh metrhth gia 20 chars
    MOV DI,0             ;Arxikopoihsh index pinaka
INPUT:    
    READ                 ;Anagnwsh eisodou
    CMP AL,61			 ;An eisodos '=', tote exoume termatismo 
    JE END_OF_PROG       
    CMP AL,0DH           ;An h eisodo einai enter exoume diakoph eisodou
    JE PRINT_INPUT      
    CMP AL,30H           ;An eisodos <30 hex, diavasma neas eisodou
    JL INPUT             
    CMP AL,39H           ;An eisodos >39 hex, tote isws gramma...
    JG MAYBE_LETTER      
    JMP ACCEPTABLE_INPUT ;...alliws arithmos
 
MAYBE_LETTER:
    CMP AL,'a'           ;An eisodos <'a', diavasma neas eisodou
    JL INPUT             
    CMP AL,'z'           ;An eisodos >'z', diavasma neas eisodou 
    JG INPUT             
    
ACCEPTABLE_INPUT:        ;Apoth_hkeush eisodou
    MOV [SYMBOLS+DI],AL
    INC DI
    LOOP INPUT           ;An CX=/=0, diavasma neas eisodou 
      
PRINT_INPUT:             
    MOV CX,20            
    MOV DI,0
OUTPUT:
    PRINT [SYMBOLS+DI]   ;Typwma charakthrwn
    INC DI
    LOOP OUTPUT
      
        
    PRNT_STR NEWLINE      
      
      
    MOV CX,20
    MOV DI,0 
                         
PRINT_LETTERS:           ;Typwma charakthrwn gia arxh 
    MOV AL,[SYMBOLS+DI]
    CMP AL,'a'           ;Elegxos an to gramma einai pezo
    JL  NOT_A_LETTER
    CMP AL,'z'
    JG NOT_A_LETTER      
    SUB AL,32            ;Kanto kefalaio
    PRINT AL             ;Typwma kefalaiwn
    
NOT_A_LETTER:            ;An den einai gramma, diavasma neas eisodou
    INC DI
    LOOP PRINT_LETTERS    
                        
    PRINT '-'
                        
    MOV CX,20
    MOV DI,0  
      
PRINT_NUMS:               ;Typwma arithmwn
    MOV AL,[SYMBOLS+DI]
    CMP AL,30H            ;Elegxos an exoume arithmo
    JL  NOT_A_NUMBER
    CMP AL,39H
    JG NOT_A_NUMBER
    PRINT AL              ;Typwma mono arithmwn
    
NOT_A_NUMBER:             ;An den einai arithmos, diavasma neas eisodou
    INC DI
    LOOP PRINT_NUMS

    PRNT_STR NEWLINE         
    JMP START
      
END_OF_PROG:
    EXIT
MAIN ENDP 
   
   
CODE_SEG ENDS
END MAIN
