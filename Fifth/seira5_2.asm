

org 100h

        TABLE EQU 00
        MOV AX,0
        MOV BX,TABLE
        MOV AL,254
LAB0:   MOV [BX],AL
        DEC AL
        INC BX
        CMP AL,0
        JA LAB0
        MOV [BX],0
        INC BX
        MOV [BX],255
        
                ;doing the calculations, in only one loop:
        MOV BX,TABLE
                ;CH will have the highest number. (initial value = all zeros)
                ;CL will have the lowest number. (initial value = all ones)
                ;the current sum of the even numbers will be calculated in SI.              
                ;DH will have the current number.
                ;DL will count how many numbers are checked.
                ;we know that all the even numbers are 128 - so there will be a division of the final content of SI with 128
                ;which means that the result (we don't care about the remainder) will be in AL.
                ;so AL will have the average.
        MOV CH,0
        MOV SI,0
        MOV CL,255
        MOV DL,255
        MOV BX,TABLE
        
        JMP LAB1
        
LAB5:   DEC DL
LAB1:   
        XCHG BX,[4500]
        MOV DH,[BX]
        INC BX
        CMP DH,CH
        JNA LAB2
        MOV CH,DH
LAB2:   CMP DH,CL
        JNB LAB3
        MOV CL,DH
LAB3:   XCHG BX,[4500]
        MOV BL,DH
        
        MOV AL,BL
        RCR AL,1
        JC LAB3B
        
        
        ADD SI,BX
        
LAB3B:  CMP DL,0
        JNE LAB5
        MOV AX,SI
        MOV BL,128  ;we don't need BX anymore, so we fill BL with the number 128
        MOV DX,0    ;<AH:AL> will be divided by 128.
        DIV BL      ;division
                    ;the result now is in (AL> and the remainder in <AH>
        
                    ;we now need to print the contents of CH (highest number), of CL (lowest number) and of (AH:AL) (average).
                    ;we will use PRINT_DEC for this, which is the same as in the exercise 5_1.
                    ;PRINT_DEC influences registers AH,AL,BH,BL,CH and CL.
                    ;we will use the stack to save contents of CX and AX. 
                    
        MOV DL,AH
        XCHG AX,[4502]
        XCHG CX,[4504]
        CALL PRINT_DEC  ;printing AH (the first part of the average)
        XCHG AX,[4502]
        MOV DL,AL
        XCHG AX,[4502]
        CALL PRINT_DEC ;printing AL (the second part of the average)
        MOV DL,10   ;new line
        MOV AH,02H
        INT 21H
        XCHG CX,[4504]
        MOV DL,CL   ;printing the smallest number
        XCHG CX,[4504]
        CALL PRINT_DEC
        XCHG CX,[4504]
        MOV DL,32   ;space
        MOV AH,02H
        INT 21H
        MOV DL,CH   ;printing the largest number
        XCHG CX,[4504]
        CALL PRINT_DEC
        HLT
                    


PRINT_DEC:          ;since the number is 8-bits, it will have at most 3 decimal digits. so we will need at most 3 addresses to save the number
        
        MOV BX,3       
        MOV [BX],'$'
        MOV AL,DL
        MOV CL,DL
        MOV DL,3
LAB4:   DEC BX
        DEC DL
        MOV CH,10
        MOV AH,0
        DIV CH
        ADD AH,48
        MOV [BX],AH
        CMP AL,0
        JA LAB4
        MOV AH,09H
        INT 21H
        MOV DL,CL
        RET