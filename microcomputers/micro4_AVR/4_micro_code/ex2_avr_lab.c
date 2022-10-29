/*
 * Authors : Petros Ellhnas, Nicolas Pigadas
 * Team82
 * AM            18702           18445
 */
#include <avr/io.h>
char x,A,B,C,D,F0=0x00,F1=0x00,N=0x00; // Arxikopoihsh eisodwn kai eksodwn twn logikwn synarthsewn

int main(void)
{
		DDRB = 0xFF; // use PORTB as output
		DDRA = 0x00; // use PORTA as input    
		
	while (1) 
    {
		x = PINA & 0x0F;   // Apomonwsh 4 LSB stoixiwn ths thyras eisodou, x = 0000 WXYZ
		                  // Katopin antistoixoume kathe pshfio 0-3 se kathe bit ths thyras eisodou A-D kata antistoixia 
						 // kai olisthsh olwn sthn prwth thesh
		A = x & 0x01;   // A = 0000 000Z
		B = x & 0x02;   // B = 0000 00Y0
		B = B>>1;       // B = 0000 000Y
		C = x & 0x04;   // C = 0000 0X00
		C = C>>2;       // C = 0000 000X 
		D = x & 0x08;   // D = 0000 W000
		D = D>>3;       // D = 0000 000W
		
		// Logikes synarthseis
		F0 = !((A & B & !C) | (C & D));
		
		F1 = ((A | B) & (C | D));
		F1 = F1<<1;
	    
		// Apotelesma
		N = F0 + F1;
		
		// Emfanish kai katopin epanelave
		PORTB = (N);
    }
}


