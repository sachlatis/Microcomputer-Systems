
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h            
                    ;DH counts how many are numbers
LABS:   MOV BX,0
        MOV CX,0
        MOV DX,0
        MOV AX,0
        MOV CL,16
LAB2:   MOV AH,08H
        INT 21H
        CMP AL,13
        JNE LAB0
        JMP LAB1        
LAB0:   CMP AL,48
        JB LAB2
        CMP AL,57
        JA LAB4
        INC DH      
        MOV [BX],AL
        INC BX
        LOOP LAB2
        CMP CX,0
        JE LAB4A
LAB4:   CMP AL,65
        JB LAB2
        CMP AL,90
        JA LAB2
        MOV [BX],AL
        INC BX
        LOOP LAB2
        
LAB4A:                    ;we have numbers in addresses 0-15.
                    ;BX has value 16.
        MOV SI,0
        MOV BP,BX
        MOV DL,DH
        MOV DH,0
        ADD BX,DX
        MOV [BX],'-'
        INC BX      ;we will add letters in the addresses where BX points at
                    ;we will add numbers in the addresses where BP points at
                    ;SI is the pointer that traverses the already saved ASCIIs
        MOV CL,16
LAB3:   MOV AL,[SI]
        CMP AL,58
        JA LAB5
        MOV [BP],AL
        INC BP
        INC SI
        LOOP LAB3
        CMP CL,0
        JE LAB6
LAB5:   ADD AL,32
        MOV [BX],AL
        INC BX
        INC SI
        LOOP LAB3
        
LAB6:   MOV [BX],10
        INC BX
        MOV [BX],'$'
        INC BX
        MOV DX,16
        MOV AH,09H
        INT 21H
        JMP LABS                                    

LAB1: HLT




