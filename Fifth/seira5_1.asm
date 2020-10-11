
org 100h

LABS:   MOV BX,3
        MOV [BX],'$'
        DEC BX
        MOV [BX],'='
        MOV DX,1
        DEC BX
        DEC BX
        MOV AX,0
        CALL HEX_KEYB  ;saves the first hex digit in AL (calls it for the first time>
        MOV AH,AL
        CMP AH,10
        JB LABSA 
        JMP LABSB
LABSA:  ADD AH,48
        JMP LABSC
LABSB:  ADD AH,55
        
LABSC:  MOV [BX],AH    ;puts it to the address of BX
        INC BX         ;increases BX by 1
        MOV CL,16
        MUL CL
        MOV CH,AL 
        
        
        CALL HEX_KEYB  ;saves the second hex digit in AL
        MOV AH,AL
        CMP AH,10
        JB LABSD
        JMP LABSE
LABSD:  ADD AH,48
        JMP LABSF
LABSE:  ADD AH,55
LABSF:  
        MOV [BX],AH    ;puts it to the address of BX
        INC BX         ;increases BX by 1
        ADD AL,CH
        
                    ;the number is now in AL
      

LAB5:               ;print the number in hex format
                    ;since the number is 8-bits, at most 2 hex bits will be needed.
                    ;number is currently in AL
        MOV DX,0
        MOV DL,AL   ;moving the number to DL
        MOV CH,DL
        MOV DX,0
        MOV AH,09H  
        INT 21H
        MOV DL,CH
        CALL PRINT_DEC  ;calling the three printing routines, firstly PRINT_DEC, then PRINT_OCT, then PRINT_BIN
        MOV BX,1
        MOV [BX],'$'
        DEC BX
        MOV [BX],'='
        MOV CH,CL
        MOV DX,0
        MOV AH,09H
        INT 21H
        MOV DL,CH
        CALL PRINT_OCT
        MOV BX,1
        MOV [BX],'$'
        DEC BX
        MOV [BX],'='
        MOV CH,CL
        MOV DX,0
        MOV AH,09H
        INT 21H
        MOV DL,CH
        CALL PRINT_BIN
        MOV BX,0
        MOV [BX],10
        INC BX
        MOV [BX],'$'
        MOV DX,0
        MOV AH,09H
        INT 21H
        JMP LABS             
        
LAB6:   HLT


HEX_KEYB:             ;waits to get 'Q' or a hex digit from the keyboard. returns the value of this hex digit in AL.

LAB3:   MOV AH,08H
        INT 21H
                CMP AL,'Q'   ;checking if Q was input
        JNE LAB3C     ;if it is Q, quit the program
        JMP LAB6
LAB3C:                ;check if the input was valid, this means, if it belongs in [48,57], [65,70] or [97,102].
        CMP AL,48
        JB LAB3
        CMP AL,57
        JBE LAB3N
        CMP AL,65
        JB LAB3
        CMP AL,70
        JBE LAB3U
        CMP AL,97
        JB LAB3
        CMP AL,102
        JBE LAB3L
        JMP LAB3
        
LAB3N:  
        SUB AL,48
        RET
        
LAB3U:  
        SUB AL,55
        RET
        
LAB3L:  
        SUB AL,87
        RET
        

        


PRINT_DEC:          ;since the number is 8-bits, it will have at most 3 decimal digits. so we will need at most 3 addresses to save the number
        
        MOV BX,3       
        MOV [BX],'$'
        MOV AL,DL
        MOV CL,DL
        MOV DL,3
LAB0:   DEC BX      ;puts the digits in order in the addresses to print them
        DEC DL
        MOV CH,10
        MOV AH,0
        DIV CH
        ADD AH,48
        MOV [BX],AH
        CMP AL,0
        JA LAB0
        MOV AH,09H
        INT 21H
        MOV DL,CL
        RET
        
PRINT_OCT:            ;255 in decimal (the maximum 8-bit value) is 377 in oct, which means that at most 3 digits will be needed.
        
        MOV BX,3        
        MOV [BX],'$'
        MOV AL,DL
        MOV CL,DL
        MOV DL,3
LAB1:   DEC BX       ;puts the digits in order in the addresses to print them
        DEC DL
        MOV CH,8
        MOV AH,0
        DIV CH
        ADD AH,48
        MOV [BX],AH
        CMP AL,0
        JA LAB1
        MOV AH,09H
        INT 21H
        MOV DL,CL
        RET        

PRINT_BIN:

        MOV BX,8        ;255 in decimal has 8 binary digits. so '$' will be stored at the 8th place.
        MOV [BX],'$'
        MOV AL,DL
        MOV CL,DL
        MOV DL,8
LAB2:   DEC BX          ;puts the digits in order in the addresses to print them
        DEC DL
        MOV CH,2
        MOV AH,0
        DIV CH
        ADD AH,48
        MOV [BX],AH
        CMP AL,0
        JA LAB2
        MOV AH,09H
        INT 21H
        MOV DL,CL
        RET
        
        
        
        
                       