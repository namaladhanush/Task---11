org 100h
jmp start

input db "Enter the Value of n: $"
output db 0Dh,0Ah, "The nth Fibonacci Number is: $"
          
fib1 db '0'
fib2 db '1'
res db '0'
          
start:
    ; Print the input prompt
    mov dx, offset input
    mov ah, 09h
    int 21h

    ; Take input from user
    mov ah, 01h
    int 21h
    sub al, '0'          ; Convert ASCII to number
    mov bl, al           ; Store n in bl
    mov cl, al           ; Store n in cl as counter

    ; Initialize Fibonacci values
    mov fib1, '0'
    sub fib1, '0'        ; First Fibonacci number as ASCII '0'
    mov fib2, '1' 
    sub fib2, '0'       ; Second Fibonacci number as ASCII '1'
    
    ; Check for n = 0 or n = 1
    cmp bl, 0
    je printfib1
    cmp bl, 1
    je printfib2

    ; Calculate nth Fibonacci number
    dec cl
    dec cl                ; Decrement cl to set correct loop count
find_fib:
    mov al, fib1
    mov dl, fib2
    add al, dl            ; Add fib1 and fib2
    mov fib1, dl          ; Update fib1
    mov fib2, al          ; Update fib2
    loop find_fib 
    mov res, al

mov ax, 0            ; Clear AX register
mov al, res           ; Move the result from BL to AL

mov cx, 10           ; Set divisor to 10 (for decimal conversion)
               
    mov dx, offset output
    mov ah, 09h
    int 21h
dec_to_ascii:
    xor dx, dx       ; Clear DX for division
    div cx           ; AX / 10 -> Quotient in AL, Remainder in DL
    ;add dl, '0'      ; Convert remainder to ASCII
    push dx          ; Store remainder on stack
    test al, al      ; Check if quotient is zero
    jnz dec_to_ascii ; Repeat if quotient is not zero

print_decimal:
    pop dx           ; Get character from stack
    mov ah, 02h      ; DOS function to display character in DL
    int 21h          ; Print character
    cmp sp, 0        ; Check if stack is empty
    jne print_decimal ; Repeat if stack not empty

printfib1:
    mov dx, offset output
    mov ah, 09h
    int 21h    
    mov dl, '0'          ; Print 0 as ASCII for n=0
    mov ah, 02h
    int 21h
    jmp endprogram

printfib2:
    mov dx, offset output
    mov ah, 09h
    int 21h
    mov dl, '1'          ; Print 1 as ASCII for n=1
    mov ah, 02h
    int 21h
    jmp endprogram  

    ; Exit program
endprogram:
    mov ah, 4Ch
    int 21h
