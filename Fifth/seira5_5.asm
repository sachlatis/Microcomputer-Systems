
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h
        
LABS:   MOV AX,0
        MOV BX,0
        MOV CX,0
        MOV DX,0
        
        MOV [BX],'S'
        INC BX
        MOV [BX],'T'
        INC BX
        MOV [BX],'A'
        INC BX
        MOV [BX],'R'
        INC BX
        MOV [BX],'T'
        INC BX
        MOV [BX],' '
        INC BX
        MOV [BX],'('
        INC BX
        MOV [BX],'Y'
        INC BX
        MOV [BX],','
        INC BX
        MOV [BX],' '
        INC BX
        MOV [BX],'N'
        INC BX
        MOV [BX],')'
        INC BX
        MOV [BX],':'
        INC BX
        MOV [BX],10
        INC BX
        MOV [BX],'$'
        MOV AH,09H
        INT 21H     ;printing the initial message
        
        MOV BX,0
        
LABSA:  MOV AH,08H
        INT 21H
        CMP AL,89
        JE LAB0A
        CMP AL,78
        JNE LABSA
        JMP LABE
        
        
LAB0A:  MOV BX,0    ;checking whether the input is valid and if it is valid, we convert it to the correct value
        MOV AH,08H
        INT 21H
        CMP AL,78
        JNE LAB0G
        JMP LABE
LAB0G:  CMP AL,48
        JB LAB0A
        CMP AL,57
        JBE LAB0B
        CMP AL,65
        JB LAB0A
        CMP AL,70
        JBE LAB0C
        CMP AL,97
        JB LAB0A
        CMP AL,102
        JA LAB0A  
        SUB AL,87
        JMP LAB0D
LAB0B:  SUB AL,48
        JMP LAB0D
LAB0C:  SUB AL,55
                
LAB0D:  MOV AH,0    ;multiplying it by 256 since it was the most significant HEX digit
        MOV DX,256
        MUL DX
        MOV SI,AX
        
LAB1A:  MOV AH,08H
        INT 21H
        CMP AL,78
        JNE LAB1G
        JMP LABE
LAB1G:  CMP AL,48
        JB LAB1A
        CMP AL,57
        JBE LAB1B
        CMP AL,65
        JB LAB1A
        CMP AL,70
        JBE LAB1C
        CMP AL,97
        JB LAB1A
        CMP AL,102
        JA LAB1A
        SUB AL,87
        JMP LAB1D
LAB1B:  SUB AL,48
        JMP LAB1D
LAB1C:  SUB AL,55

LAB1D:  MOV AH,0    ;multiplying it by 16 and adding it to the former result since it is the second most significant HEX digit
        MOV DX,16
        MUL DX
        ADD SI,AX
        
LAB2A:  MOV AH,08H
        INT 21H
        CMP AL,78
        JNE LAB2G
        JMP LABE
LAB2G:        
        CMP AL,48
        JB LAB2A
        CMP AL,57
        JBE LAB2B
        CMP AL,65
        JB LAB2A
        CMP AL,70
        JBE LAB2C
        CMP AL,97
        JB LAB2A
        CMP AL,102
        JA LAB2A
        SUB AL,87
        JMP LAB2D
LAB2B:  SUB AL,48
        JMP LAB2D
LAB2C:  SUB AL,55

LAB2D:  MOV AH,0
        ADD SI,AX   ;adding the least significant HEX digit to the result                      
        
                    ;right now SI has the 3 digit HEX number.
                    
        MOV DX,0
        MOV BX,0
        MOV CX,0
        MOV AX,0    ;cleaning the other registers
        
                    ;we need to find where the number is.
                    
        CMP SI,4095 
        JB LAB3
        JMP LAB3E
        
LAB3:   CMP SI,3685
        JNA LAB3A
        JMP LAB5
        
LAB3A:  CMP SI,2047
        JNA LAB3C
        JMP LAB4
        
LAB3C:              ;it goes here if 0 <= SI <= 2047.
                    
        MOV AX,SI   ;the result (in temperature is SI * 500 / 2047.5 = SI * 1000 / 4095).
                    ;the product will be in DH:DL:AH:AL.
        MOV CX,1000
        MUL CX      ;we will make the division with 4095, then will multiply the remainder by 10
                    ;and divide the remainder again with 4095. the new result will be the decimal,
                    ;which will increase by 1 if the new remainder is 2048 or more (if the result is 9
                    ;and the new remainder is 2048 or more, the number increases by 1), or will stay 
                    ;as is if the new remainder is 2047 or less.
        MOV CX,4095
        DIV CX
        MOV CX,AX   ;the result is now in CX
        MOV AX,DX   ;the remainder is now in AX
        JMP LAB3F

        
        
LAB4:               ;in this case, the result is 500 + 250 * ((SI-2047.5)/2047.5) = 500 + 250 * ((2*SI - 4095)/4095).
                    ;the integer part will be in CX and the first decimal in AL.
                    ;we will now calculate 2*SI - 4095.
        MOV AX,SI
        MOV CX,2
        MUL CX
        SUB AX,4095
                    ;we will calculate 250 * (2*SI - 4095).
        
        MOV CX,250
        
        MUL CX      
                    ;the number 250 * (2*SI - 4095) is in DX:AX.
        MOV CX,4095
        DIV CX
        MOV CX,AX   ;the result of 250 * (2*SI - 4095) / 4095 is in CX
        MOV AX,DX   ;the remainder is in AX
        
        ADD CX,500  ;adding 500 to the result, so we have 500 + 250 * ((2*SI - 4095)/4095) in the result, without decimal adjustment.                                    
        JMP LAB3F
        
LAB5:               ;in this case, the result is 700 + 1500 * ((10*SI - 36855)/20475).
                    ;the integer part will be in CX and the first decimal in AL.
                    ;we will now calculate 10*SI - 36855.
                    
        MOV AX,SI
        MOV CX,10
        MUL CX
        SUB AX,36855
        MOV CX,1500
        MUL CX      ;the product will be in DH:DL:AH:AL.
        
        MOV CX,20475    ;we will make the division with 20475.
        DIV CX
        MOV CX,AX   ;the result of 1500 * ((10*SI - 36855)/20475) is in CX
        MOV AX,DX   ;the remainder is in AX
        
        ADD CX,700  ;adding 700 to the result, so we have 700 + 1500 * ((10*SI - 36855)/20475) in the result, without decimal adjustment.                    
        
        MOV DX,10
        MUL DX      ;the product of REMAINDER*10 is in DX:AX.
        
        MOV BX,20475
        DIV BX      ;dividing REMAINDER*10 with 20475 again.
                    ;now AH must be 0, AL has the first decimal digit
                    ;DX has the NEW_REMAINDER.
        CMP DX,10238
        JB LAB6
        CMP AL,9
        JB LAB3B
        INC CX
        MOV AL,0
        JMP LAB6            
                          
                    
LAB3F:  MOV DX,10
        MUL DX      ;the product of REMAINDER*10 is in DX:AX.
        
        MOV BX,4095
        DIV BX      ;dividing REMAINDER*10 with 4095 again.
                    ;now AH must be 0, AL has the first decimal digit
                    ;DX has the NEW_REMAINDER.
        
        CMP DX,2048
        JB LAB6    ;if the NEW_REMAINDER is less than 2048, print CX.AL
        
                    ;else, check if AL is 9
        CMP AL,9
        JB LAB3B    ;if the first decimal digit was less than 9, increase it by 1
                    ;else, increase the whole number by 1 and make the decimal digit 0
        INC CX
        MOV AL,0
        JMP LAB6
        
LAB3B:  INC AL
        JMP LAB6                    
                    
        
LAB6:   MOV BX,0    ;right now, the result is in CX and the first decimal in AL, correctly adjusted.
        MOV DL,AL   ;temporarily store AL in DL
        MOV AX,CX   ;save the result in AX
        MOV CL,DL   ;save the first decimal in CL
                    
                    ;right now, the result is in AX and the first decimal in CL, correctly adjusted.
                    
                    ;we will proceed printing the result.
                    
        MOV DX,0    ;cleaning register DX
        
        MOV CH,0    ;register CH will count how many digits the integer part has
        MOV SI,AX   ;temporarily save the number in SI            
LAB6B:
        
        MOV DL,10
        DIV DL
        INC CH
        MOV AH,0
        CMP AX,0
        JA LAB6B
        
                    
        
        MOV AX,SI   ;get the number back
        MOV BL,CH   ;initially BX will have the number of digits as value, minus one (since we will begin from 0)
        DEC BX
        MOV DL,10
LAB6A:  DIV DL
        ADD AH,48
        MOV [BX],AH
        DEC BX
        MOV AH,0
        CMP AX,0
        JA LAB6A
        
        INC BX            
        ADD BL,CH   ;add the number of digits back to complete the decimal part and the end of the string
        MOV [BX],'.'
        INC BX
        ADD CL,48
        MOV [BX],CL
        INC BX
        MOV [BX],248
        INC BX
        MOV [BX],'C'
        INC BX
        MOV [BX],' '
        INC BX
        MOV DX,0
        MOV [BX],'$'
        MOV AH,09H
        INT 21H                    
                                            
                               
        JMP LAB0A
                    
LAB3E:  MOV BX,0     ;in case the temperature is more than 999.9oC, print error message
        MOV [BX],'E'
        INC BX
        MOV [BX],'R'
        INC BX
        MOV [BX],'R'
        INC BX
        MOV [BX],'O'
        INC BX
        MOV [BX],'R'
        INC BX  
        MOV [BX],' '
        INC BX
        MOV [BX],'$'
        MOV DX,0
        MOV AH,09H
        INT 21H
        JMP LAB0A         
        
LABE:   HLT




