.MODEL SMALL
.STACK 100H
.DATA
 num DB 6 ; Input number (change as needed)
 factorial DW 1 ; To store the factorial result, initialized to 1
 message DB 'Factorial is: $'
 result DB '0000$' ; Buffer to store the ASCII result (supports up to 4 digits)
.CODE
MAIN PROC
 MOV AX, @DATA ; Initialize data segment
 MOV DS, AX
 ; Load the input number
 MOV AL, num ; Load the input number into AL
 MOV AH, 0 ; Clear the upper byte of AX
 MOV CX, AX ; Move the value from AX to CX (16-bit compatible)
 ; Check if number is 0 (special case, factorial of 0 is 1)
 CMP CX, 0
 JE DONE ; If 0, skip to DONE (factorial is already 1)
 ; Calculate factorial in a loop (include the initial value in CX)
FACTORIAL_LOOP:
 MOV AX, factorial ; Load current factorial value
 MUL CX ; Multiply AX by CX (result in DX:AX)
 MOV factorial, AX ; Store result back in factorial (assume result fits in AX)
 DEC CX ; Decrement CX (counter)
 JNZ FACTORIAL_LOOP ; Repeat until CX becomes zero
DONE:
 ; Convert the factorial result to ASCII for printing
 MOV AX, factorial ; Load the factorial result into AX
 MOV SI, OFFSET result + 3 ; Start from the last digit position in result buffer
 MOV BX, 10 ; Divisor for decimal conversion
CONVERT_LOOP:
 XOR DX, DX ; Clear DX before DIV (high 16 bits)
 DIV BX ; Divide AX by 10, quotient in AX, remainder in DX
 ADD DL, '0' ; Convert remainder to ASCII
 MOV [SI], DL ; Store ASCII character in result buffer
 DEC SI ; Move to the next position
 CMP AX, 0 ; Check if quotient is zero
 JNZ CONVERT_LOOP ; If not, repeat
 ; Display the message "Factorial is: "
 MOV DX, OFFSET message
 MOV AH, 09H ; DOS function to display string
 INT 21H
 ; Display the factorial result
 MOV DX, OFFSET result
 MOV AH, 09H ; DOS function to display string
 INT 21H
 ; End program
 MOV AH, 4CH ; DOS terminate program
 INT 21H
MAIN ENDP
END MAIN