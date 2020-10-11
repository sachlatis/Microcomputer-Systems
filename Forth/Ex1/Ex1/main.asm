;
; partA.asm
;

.include "m16def.inc"

reset: 
	ldi r24 , low(RAMEND)	; initialize stack pointer
	out SPL , r24
	ldi r24 , high(RAMEND)
	out SPH , r24
	ser r24 
	out DDRB , r24	; initialize PORTB for output
	;clr r24 ; ��� ���������� �� ������ ��� �� 8 �������
	ldi r24, $02
	out DDRC, r24	; initialize PORTC for input
	ldi r26, 1	; ������������ ��� r26 �� 1 

increase:	; �������� �������� bit
	in r27, PINC	; ������� ������� ��� ������� ������� ��� push button PC2
	ror r27	; �� ����� �������� ��� ������� ��� ������� ���
	ror r27
	ror r27
	brcs increase	; ����������� ��� ����������� ��� LSB ������ �� PC2
	out PORTB, r26	; �������� ������ ��� PORTB
	ldi r24, low(500) ; load r25:r24 with 500
	ldi r25, low(500) ; delay 1 sec
	;rcall wait_msec ;��� ��� �����������
	lsl r26		;�������� ��������
	cpi r26, 128	;������� �� ����� ���������� ��� 128
	brlo increase	; �� ���, ���� ���� ��� increase
	rjmp decrease	; �� ���, ���� ��� decrease

decrease:	;���������� ��� ����� �������� ��� bit
	in r27, PINC
	ror r27
	ror r27
	ror r27
	brcs decrease
	out PORTB, r26
	ldi r24, low(500)
	ldi r25, low(500)
	;rcall wait_msec
	lsr r26
	cpi r26,2	; ������� �� ����� ���������� � ��� ��� 2
	brge decrease
	rjmp increase

wait_msec:
	push r24 ; 2 ������ (0.250 �sec)
	push r25 ; 2 ������
	ldi r24 , low(998) ; ������� ��� �����. r25:r24 �� 998 (1 ������ - 0.125 �sec)
	ldi r25 , high(998) ; 1 ������ (0.125 �sec)
	rcall wait_usec ; 3 ������ (0.375 �sec), �������� �������� ����������� 998.375 �sec
	pop r25 ; 2 ������ (0.250 �sec)
	pop r24 ; 2 ������
	sbiw r24 , 1 ; 2 ������
	brne wait_msec ; 1 � 2 ������ (0.125 � 0.250 �sec)
	ret ; 4 ������ (0.500 �sec)

wait_usec:
	sbiw r24 ,1 ; 2 ������ (0.250 �sec)
	nop ; 1 ������ (0.125 �sec)
	nop ; 1 ������ (0.125 �sec)
	nop ; 1 ������ (0.125 �sec)
	nop ; 1 ������ (0.125 �sec)
	brne wait_usec ; 1 � 2 ������ (0.125 � 0.250 �sec)
	ret ; 4 ������ (0.500 �sec)