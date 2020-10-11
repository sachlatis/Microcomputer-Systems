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
	;clr r24 ; δεν χρειαζεται να εχουμε και τα 8 ανοικτα
	ldi r24, $02
	out DDRC, r24	; initialize PORTC for input
	ldi r26, 1	; αρχικοπόιύμε τον r26 με 1 

increase:	; αριστερή ολίσθηση bit
	in r27, PINC	; φόρτωση εισόδου και συνθήκη ελέγχου του push button PC2
	ror r27	; με δεξια ολίσθηση της εισόδου και έλεγχος του
	ror r27
	ror r27
	brcs increase	; κρατουμένου που αντιστοιχεί στο LSB δηλαδή το PC2
	out PORTB, r26	; εμφάνιση εξόδου στο PORTB
	ldi r24, low(500) ; load r25:r24 with 500
	ldi r25, low(500) ; delay 1 sec
	;rcall wait_msec ;για την προσομοίωση
	lsl r26		;αριστερή ολίσθηση
	cpi r26, 128	;έλεγχος αν είναι μικρότερος του 128
	brlo increase	; αν ναι, τότε πάμε στο increase
	rjmp decrease	; αν όχι, πάμε στο decrease

decrease:	;αντίστοιχα για δεξιά ολίσθηση του bit
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
	cpi r26,2	; έλεγχος αν είναι μεγαλύτερο ή ίσο του 2
	brge decrease
	rjmp increase

wait_msec:
	push r24 ; 2 κύκλοι (0.250 μsec)
	push r25 ; 2 κύκλοι
	ldi r24 , low(998) ; φόρτωσε τον καταχ. r25:r24 με 998 (1 κύκλος - 0.125 μsec)
	ldi r25 , high(998) ; 1 κύκλος (0.125 μsec)
	rcall wait_usec ; 3 κύκλοι (0.375 μsec), προκαλεί συνολικά καθυστέρηση 998.375 μsec
	pop r25 ; 2 κύκλοι (0.250 μsec)
	pop r24 ; 2 κύκλοι
	sbiw r24 , 1 ; 2 κύκλοι
	brne wait_msec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
	ret ; 4 κύκλοι (0.500 μsec)

wait_usec:
	sbiw r24 ,1 ; 2 κύκλοι (0.250 μsec)
	nop ; 1 κύκλος (0.125 μsec)
	nop ; 1 κύκλος (0.125 μsec)
	nop ; 1 κύκλος (0.125 μsec)
	nop ; 1 κύκλος (0.125 μsec)
	brne wait_usec ; 1 ή 2 κύκλοι (0.125 ή 0.250 μsec)
	ret ; 4 κύκλοι (0.500 μsec)