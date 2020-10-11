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
    DDRB = 0xFF;           //������� ��� ����� ��� PORTB.
	DDRA = 0x00;           //������� ��� ������ ��� PORTA
	
	x = 1;                //������ ������ �� led0
	
	while(1) {
		if((PINA & 0x01) == 1){      //������� ��������� SW0
		  while((PINA & 0x01) == 1); //������� ���������� SW0
		  if(x==1) 
		       x = 128;              //������� ������������
		  else x = x >> 1;
		}
		
		if((PINA & 0x02) == 2){         //������� ��������� SW1
			while((PINA & 0x02) == 2);  //������� ���������� SW1
			if(x==128)                  
			     x = 1;                 //������� ������������
			else x = x << 1;
		}
		
		if((PINA & 0x04) == 4){         //������� ��������� SW2
			while((PINA & 0x04) == 4);  //������� ���������� SW2
			x = 1;            //���������� ��������� LED ��� led0 (lsb)
		}
		
		if((PINA & 0x08) == 8){         //������� ��������� SW3
			while((PINA & 0x08) == 8);  //������� ���������� SW3
			x = 128;          //���������� ��������� LED ��� led7 (msb)
		}
		
		PORTB = x;      //������ ���� PORTB
	}
	return 0;
}

