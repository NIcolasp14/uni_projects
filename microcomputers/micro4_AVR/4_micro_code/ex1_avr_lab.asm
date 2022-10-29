 ; Authors : Petros Ellhnas, Nicolas Pigadas
 ; Team82
 ; AM            18702           18445
 
ldi r24 , low(RAMEND)  ; Arxikopoihsh stack pointer
out SPL , r24
ldi r24 , high(RAMEND)
out SPH , r24

ser r25                ; Thetoyme mono assous ston r25
out DDRA,r25           ; Xrhsh PORTA ws output
clr r25                ; Thetoume mono mhdenika ston r25
out DDRB,r25           ; Xrhsh PORTB ws input

init:
	ldi r28,0x00000000 ; Arxikopoihsh tou PB0 me 0, afoy den einai pathmeno arxika kai ksekinaei to rotation
	out PORTB,r28 
	ldi r28,0x00000001 ; Arxikopoihsh lampakiwn sto led0
	out PORTA,r28    
    ldi r29,0x00       ; Flag phgainw apo lsb se msb h antitheta?
	nop                ; ~250 ms delayn x2
	nop

loop: 
	sbic PINB,0x00     ; skip the next instr if PB0=0
	rjmp stay          ; else, make no move
	rjmp cont          ; if you skipped, let's rotate
	  
cont: 
	cpi r28,0x80       ; An eimaste sto led7 pame apo ta msb sta lsb
	breq msblsb
	cpi r28,0x01       ; An eimaste sto led0 pame apo ta lsb sta msb
	breq lsbmsb  
	rjmp ipologise     ; An eisai se endiameso, exontas to FLAG, kane swsto rotation

lsbmsb: 
	ldi r29,0x00       ; FLAG = 0 shmainei oti exw kateythynsh apo ta lsb sta msb
    rjmp ipologise     ; Hrthes edw epeidh allakses poreia, eftiakses to flag, ksekina to rotation

msblsb: 
	ldi r29,0x01       ; FLAG = 1 shmainei oti exw kateythynsh apo ta msb sta lsb

ipologise: 
	cpi r29,0x01       ; An FLAG == 1 tote kane rotation apo ta msb pros ta lsb (lsr) (****)
    breq piso
	lsl r28            ; An FLAG == 0 tote kane rotation apo ta lsb pros ta msb (lsl)
		               ; An synexiseis apo edw kai katw phgaine na anapseis to left-rotated led

output:	
        out PORTA,r28  ; Anavei to rotaded led
		nop            ; ~250 ms delay x2
		nop
		rjmp loop      ; Epanalave

piso:   
	lsr r28                  
    rjmp output        ; Phgaine na anapseis to right-rotated led
	   
stay:                  ; Enallages etiketwn loop kai stay mexri to PB0 na vrethei na mhn einai pathmeno
	; out PORTA, r28   ; Den xreiazetai output epeidh einai hdh anammeno to led gia thn katastash stay kai to afhnoume ws exei
	rjmp loop



