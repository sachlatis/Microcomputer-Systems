#include <avr/io.h>
int main(void)
{
	DDRB=0x00;				//as input
	DDRA=0xFF;				//as output
	while (1)
	{
		char IN= PINB;								//reading input
		char A=(IN >> 0) & 1;						//getting from 8bits input the A,B,C,D
		char B=(IN >> 1) & 1;						//masking with the 0x01 after shifting the bits to get the nth bit at the LSB position
		char C=(IN >> 2) & 1;
		char D=(IN >> 3) & 1;

		char F0 = ~((A & (~B) )| (B & (~C) & D));	//creating the output logic function
		F0=F0 &1;									//only the LSB
		char F1 =((A|C)&(B|D));
		F1=F1 &1;
		
		PORTA=F0 +(F1<<1);							//export output at portA with F0 in LSB and F1 in the 2nd LSB
	}
}

