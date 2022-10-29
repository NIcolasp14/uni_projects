/*
 * Authors : Petros Ellhnas, Nicolas Pigadas
 * Team82
 * AM            18702           18445
 */

#include <avr/io.h> 

int main(void)
{
	DDRA=0XFF; //Output
	DDRC=0X00; //Input
	char Current_state=0x01; //Arxikopoihsh twn leds me anamma tou prwtou
	PORTA = Current_state;   //dhladh ths theshs 0 ths thyras eksodou PORTA
	
	
    while (1) 
    {
		//H antistoixia twn diakoptwn SWx sta bit ths thyras eisodou PORTC
		//SW0 = (PINC & 0x01);
		//SW1 = (PINC & 0x02);
		//SW2 = (PINC & 0x04);
		//SW3 = (PINC & 0x08);
		
		//SW0
		if((PINC & 0x01)==1){                 //Elegxos pathmatos push-button SW0
			while((PINC & 0x01)==1);         //Elegxos epanaforas push-button SW0
				if(Current_state==0x80)     //An eimaste sto PA7, synexizoume apo to PA0
					Current_state=0x01;
				else                      //Alliws kanoume olisthsh pros ta aristera
					Current_state=Current_state << 1; 
			
				PORTA = Current_state;  //Emfanish sthn eksodo
		}
		
		//SW1
		if((PINC & 0x02)==2){                //Elegxos pathmatos push-button SW1 me 2 (maska 10 sto dyadiko)
			while((PINC & 0x02) == 2);      //Elegxos epanaforas push-button SW1
				if(Current_state==0x01)    //An eimaste sto PA0, synexizoume apo to PA7
					Current_state=0x80;
				else                     //Alliws kanoume olisthsh pros ta deksia
					Current_state=Current_state >> 1; 
				
			PORTA = Current_state;	   //Emfanish sthn eksodo
		}
		
		//SW2
		if((PINC & 0x04)==4){               //Elegxos pathmatos push-button SW2 me 4 (maska 100 sto dyadiko) 
			while((PINC & 0x04)==4);       //Elegxos epanaforas push-button SW2
				Current_state=0x80;       //Metakihsh tou anammenou led sthn thesh MSB(led7)
				PORTA=Current_state;
		}
		
		//SW3
		if((PINC & 0x08)==8){               //Elegxos pathmatos push-button SW3 me 8 (maska 1000 sto dyadiko)
			while((PINC & 0x08)==8);       //Elegxos epanaforas push-button SW3
				Current_state=0x01;       //Metakihsh tou anammenou led sthn thesh LSB(led0)
				PORTA=Current_state;
		}
    }
}
