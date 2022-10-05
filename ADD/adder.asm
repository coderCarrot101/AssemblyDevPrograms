
include \masm32\include\masm32rt.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib

INCLUDELIB kernel32.lib
INCLUDELIB masm32.lib

cdMaxSize  EQU 11


.DATA?
  szNumber1 DB cdMaxSize dup(?)
  szNumber2 DB cdMaxSize dup(?)
  iNum      DD ?
 
.DATA
  szTxtNum1 DB "Your first number: ", 0
  szTxtNum2 DB "Your second number: ", 0
  szTxtSum  DB "Both sum: ", 0
  number1   DD 442
  number2   DD 22
  msg       DB cdMaxSize dup(0)
 
.CODE
  num2stri PROC uses ebx edx esi
    ; this is used after the math to convert the numbers back to a readable format and show the answer
    ; In: eax, the value
    ; Out: eax, the value converted to string format
    MOV     esi, offset msg + cdMaxSize - 1
    MOV     ebx, 10
    @Next:
      DEC     esi
      XOR     edx, edx
      div     ebx
      OR      edx, 30h
      mov     byte ptr [esi], dl
      OR      eax, eax
    JNZ     @Next
    MOV     eax, esi
    RET
  num2stri ENDP
 
  str2num PROC uses ebx ecx edx esi edi
    ; this gets the string that the user gave and turned it into a number for math opperations
    ; In: eax, the string
    ; out: eax, the string converted to a number
    MOV     edi, eax
    MOV     eax, 0
    MOV     ecx, cdMaxSize
    REPNE   SCASB
    JNZ     @NoFound
    SUB     edi, 2
    SUB     ecx, cdMaxSize
    NEG     ecx
    MOV     ebx, 1
    MOV     esi, 0
    @Next:
      DEC     ecx
      JL      @Exit
      XOR     eax, eax
      MOV     al, byte ptr [edi]
      AND     al, 15
      MUL     ebx
      ADD     esi, eax
      MOV     eax, ebx
      MOV     ebx, 10
      MUL     ebx
      MOV     ebx, eax
      DEC     edi
    JMP     @Next
    @Exit:
    MOV     eax, esi
    @NoFound:
    RET
  str2num endp

  start:
    ; gets user input
    INVOKE     StdOut, offset szTxtNum1
    INVOKE     StdIn, offset szNumber1, cdMaxSize
    INVOKE     StdOut, offset szTxtNum2
    INVOKE     StdIn, offset szNumber2, cdMaxSize
   
    ; Converts the string to numbers
    MOV        eax, offset szNumber1
    CALL       str2num
    MOV        ebx, eax
   
    MOV        eax, offset szNumber2
    CALL       str2num
    ADD        ebx, eax
   
    ; Show the result
    INVOKE     StdOut, offset szTxtSum
    MOV        eax, ebx
    CALL       num2stri
    INVOKE     StdOut, eax
    INVOKE     ExitProcess, 0
 
END start

to_string ENDP 
end start ;ends this thing
