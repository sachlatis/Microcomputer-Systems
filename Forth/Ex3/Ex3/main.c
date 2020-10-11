/*/*
 * GccApplication4.c
 *
 * Created: 26-May-20 10:44:25 AM
 * Author : hp 250 w4
 */ 

#include <avr/io.h>

char x;

int main(void)
{
    DDRB = 0xFF;           //Θέτουμε την έξοδο στο PORTB.
	DDRA = 0x00;           //Θέτουμε την είσοδο στο PORTA
	
	x = 1;                //Αρχικά ανάβει το led0
	
	while(1) {
		if((PINA & 0x01) == 1){      //Έλεγχος πατήματος SW0
		  while((PINA & 0x01) == 1); //Έλεγχος επαναφοράς SW0
		  if(x==1) 
		       x = 128;              //Έλεγχος υπερχείλισης
		  else x = x >> 1;
		}
		
		if((PINA & 0x02) == 2){         //Έλεγχος πατήματος SW1
			while((PINA & 0x02) == 2);  //Έλεγχος επαναφοράς SW1
			if(x==128)                  
			     x = 1;                 //Έλεγχος υπερχείλισης
			else x = x << 1;
		}
		
		if((PINA & 0x04) == 4){         //Έλεγχος πατήματος SW2
			while((PINA & 0x04) == 4);  //Έλεγχος επαναφοράς SW2
			x = 1;            //Μετακίνηση αναμμένου LED στο led0 (lsb)
		}
		
		if((PINA & 0x08) == 8){         //Έλεγχος πατήματος SW3
			while((PINA & 0x08) == 8);  //Έλεγχος επαναφοράς SW3
			x = 128;          //Μετακίνηση αναμμένου LED στο led7 (msb)
		}
		
		PORTB = x;      //Έξοδος στην PORTB
	}
	return 0;
}

