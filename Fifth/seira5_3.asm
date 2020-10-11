
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h

        MOV AH,08H  ;asking for first digit
        INT 21H
        MOV CH,AL   ;saving first digit in CH
        INT 21H     ;asking for second digit
        MOV CL,AL   ;saving second digit in CL
        INT 21H     ;asking for third digit (first of second number)
        MOV DH, AL  ;saving third digit in DH
        INT 21H     ;asking for fourth digit (second of second number)
        MOV DL, AL  ;saving fourth digit in DL
        
                    ;we will firstly print the two numbers
                    
        MOV AH,09H
        MOV BX,0    ;annuling BX
        MOV [BX],'x'
        INC BX
        MOV [BX],'='
        INC BX
        MOV [BX],CH
        INC BX
        MOV [BX],CL
        INC BX
        MOV [BX],' '
        INC BX
        MOV [BX],'y'
        INC BX
        MOV [BX],'='
        INC BX
        MOV [BX],DH
        INC BX
        MOV [BX],DL
        INC BX
        MOV [BX],10 ;change line
        INC BX
        MOV [BX],'$'
        
        CMP CH,57
        JLE LAB0
        CMP CH,70
        JLE LAB1
        SUB CH,87
        JMP LAB2
LAB0:   SUB CH,48
        JMP LAB2
LAB1:   SUB CH,55

LAB2:   CMP CL,57
        JLE LAB3
        CMP CL,70
        JLE LAB4
        SUB CL,87
        JMP LAB5
LAB3:   SUB CL,48
        JMP LAB5
LAB4:   SUB CL,55
        
LAB5:   CMP DH,57
        JLE LAB6
        CMP DH,70
        JLE LAB7
        SUB DH,87
        JMP LAB8
LAB6:   SUB DH,48
        JMP LAB8
LAB7:   SUB DH,55

LAB8:   CMP DL,57
        JLE LAB9
        CMP DL,70
        JLE LAB10
        SUB DL,87
        JMP LAB11
LAB9:   SUB DL,48
        JMP LAB11
LAB10:  SUB DL,55

LAB11:  XCHG DX,[4502]

        MOV DX,0
        MOV AH,09H
        INT 21H     ;printing x=[CH][CL], y=[DH][DL]
        
        XCHG DX,[4502]
        
                    ;we will now print the sum and the difference of the two numbers in decimal form.
                    ;we firstly need to convert each digit to its respective value.

              
                    ;we will now save the first number in CH and the second number in CL
        MOV AH,16
        MOV AL,CH
        MUL AH
        ADD AL,CL   ;now AL has the first number
        MOV CH,AL   ;now CH has the first number
        
        MOV AH,16
        MOV AL,DH
        MUL AH
        ADD AL,DL   ;now AL has the second number
        MOV CL,AL   ;now CL has the second number
                    
                    ;CH and CL have first and second number.
                    ;BX will keep the addresses in which the digits will be stored at
                    ;SI will have the sum
                    ;DI will have the difference
                    ;AX and DX will be used for divisions, retrieving the digits
                    
        MOV BX,0
        MOV AX,0
        MOV SI,0
        MOV DI,0    ;initializing the registers
        
        MOV [BX],'x'
        INC BX
        MOV [BX],'+'
        INC BX
        MOV [BX],'y'
        INC BX
        MOV [BX],'='
        INC BX      
        
        MOV AL,CH
        ADD SI,AX
        MOV AL,CL
        ADD SI,AX   ;now SI has the sum
        
        

       
        MOV AX,SI
        MOV DL,10
        MOV DH,0
LAB13:  DIV DL
        INC DH      ;DH will count how many digits the number has.
        MOV AH,0
        CMP AX,0
        JG LAB13     ;we are done with storing the sum in the addresses, but it is stored in the wrong digit order.
                    ;to store it normally, we will reverse the digits in these addresses.
        
        SUB DH,1
        ADD BL,DH
        ADD DH,2
        MOV AX,SI
        MOV DL,10
LAB13A: DIV DL
        ADD AH,48
        MOV [BX],AH
        DEC BX
        MOV AH,0
        CMP AX,0
        JG LAB13A
        
        ADD BL,DH                        
                    
        MOV [BX],' '
        INC BX            
        MOV [BX],'x'
        INC BX
        MOV [BX],'-'
        INC BX
        MOV [BX],'y'
        INC BX
        MOV [BX],'='
        INC BX                    
        
        CMP CH,CL
        JB LAB14
        JMP LAB15
        
        
LAB14:  MOV [BX],'-'
        INC BX
        MOV AL,CH   ;making CH bigger than CL
        MOV CH,CL
        MOV CL,AL
        
LAB15:  MOV AH,0
        MOV AL,CH
        MOV DI,AX
        MOV AL,CL
        SUB DI,AX
        
        MOV AX,DI
        MOV DL,10
        MOV DH,0
LAB16:  DIV DL
        INC DH      ;DH will count how many digits the number has.
        MOV AH,0
        CMP AX,0
        JG LAB16     ;we are done with storing the sum in the addresses, but it is stored in the wrong digit order.
                    ;to store it normally, we will reverse the digits in these addresses.
        
        SUB DH,1
        ADD BL,DH
        ADD DH,2
        MOV AX,DI
        MOV DL,10
LAB16A: DIV DL
        ADD AH,48
        MOV [BX],AH
        DEC BX
        MOV AH,0
        CMP AX,0
        JG LAB16A
        
        ADD BL,DH
        MOV [BX],'$'
        
        MOV DX,0
        MOV AH,09H
        INT 21H
        
        HLT                