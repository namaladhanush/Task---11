org 100h

jmp start

input1 db "Enter the First Digit: $"
input2 db 0Dh,0Ah,"Enter the Second Digit: $"
output db 0Dh,0Ah,"LCM of the Given two numbers is: $"

start:
    ; Display "Enter the First Digit:"
    mov dx, offset input1
    mov ah, 09h
    int 21h  

    ; Read first digit
    mov ah, 01h
    int 21h
    sub al, '0'       ; Convert ASCII to numerical value
    mov cl, al        ; Store first number in CL

    ; Display "Enter the Second Digit:"
    mov dx, offset input2
    mov ah, 09h
    int 21h

    ; Read second digit
    mov ah, 01h
    int 21h
    sub al, '0'       ; Convert ASCII to numerical value
    mov ch, al        ; Store second number in CH

    ; Copy CL and CH to registers for GCD calculation
    mov al, cl        ; AL = first number
    mov bl, ch        ; BL = second number

GCD_LOOP:
    cmp bl, 0
    je DONE_GCD
    mov ah, 0
    div bl            ; Divide AL by BL, remainder in AH, quotient in AL
    mov al, bl
    mov bl, ah
    jmp GCD_LOOP

DONE_GCD:
    ; Now AL contains the GCD
    mov bh, al        ; Store GCD in BH

    ; Calculate LCM = (CL * CH) / GCD
    mov al, cl        ; AL = first number
    mul ch            ; AX = AL * CH (product of the two numbers)

    mov bl, bh        ; Move GCD to BL
    div bl            ; AX / GCD, result in AL
    
    mov bl, al
    ; Display "LCM of the Given two numbers is:"
    mov dx, offset output
    mov ah, 09h
    int 21h 


mov ax, 0            ; Clear AX register
mov al, bl           ; Move the result from BL to AL

mov cx, 10           ; Set divisor to 10 (for decimal conversion)

dec_to_ascii:
    xor dx, dx       ; Clear DX for division
    div cx           ; AX / 10 -> Quotient in AL, Remainder in DL
    add dl, '0'      ; Convert remainder to ASCII
    push dx          ; Store remainder on stack
    test al, al      ; Check if quotient is zero
    jnz dec_to_ascii ; Repeat if quotient is not zero

print_decimal:
    pop dx           ; Get character from stack
    mov ah, 02h      ; DOS function to display character in DL
    int 21h          ; Print character
    cmp sp, 0        ; Check if stack is empty
    jne print_decimal ; Repeat if stack not empty

    ; Exit program
    mov ah, 4Ch
    int 21h