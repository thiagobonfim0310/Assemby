.686
.model flat,stdcall
option casemap:none
include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
includelib \masm32\lib\kernel32.lib
include \masm32\include\masm32.inc 
includelib \masm32\lib\masm32.lib

.data

cara_escrito dd 0;

array DWORD 127 dup(0)

handle_out DWORD 0

handle_in DWORD 0

pulei DWORD 0ah, 0h

cont DWORD 0

lidos dd 0

entrada DWORD 0

string_covert db 10 dup(0)

espaco byte " ", 0h

tam_string DWORD 0

peguei DWORD 0

.code



hanoi:

push ebp
mov ebp, esp
sub esp, 16

;---------------passando para variaveis locais-----------------------------


mov eax, DWORD PTR[ebp+20]
mov DWORD PTR[ebp-4], eax
mov eax, DWORD PTR[ebp+16]
mov DWORD PTR[ebp-8], eax
mov eax, DWORD PTR[ebp+12]
mov DWORD PTR[ebp-12], eax
mov eax, DWORD PTR[ebp+8]
mov DWORD PTR[ebp-16], eax



;--------------------------------------------------------------------------
cmp DWORD PTR[ebp-16], 1
jbe condition



mov eax, DWORD PTR[ebp+8]
dec eax
mov DWORD PTR [ebp+8], eax
push DWORD PTR [ebp+20]
push DWORD PTR [ebp+12]
push DWORD PTR [ebp+16]
push DWORD PTR [ebp+8]




call hanoi

mov edx, 0
conditionNovo:
inc edx
cmp array[edx*4], 0
jne conditionNovo
mov ecx, DWORD PTR[ebp-4]
mov array[edx*4], ecx
mov ecx, DWORD PTR[ebp-8]
inc edx
mov array[edx*4], ecx


add esp, 16





mov eax, DWORD PTR[ebp-16]
dec eax
mov DWORD PTR [ebp-16], eax
push DWORD PTR [ebp-12]
push DWORD PTR [ebp-8]
push DWORD PTR [ebp-4]
push DWORD PTR [ebp-16]

call hanoi

add esp, 16




mov esp, ebp
pop ebp
ret



condition:


mov edx, 0
conditionb:
inc edx
cmp array[edx*4], 0
jne conditionb
mov ecx, DWORD PTR[ebp-4]
mov array[edx*4], ecx
mov ecx, DWORD PTR[ebp-8]
inc edx
mov array[edx*4], ecx

mov esp, ebp
pop ebp
ret

start:


invoke GetStdHandle, STD_INPUT_HANDLE
mov handle_in, eax
invoke ReadConsole, handle_in, addr entrada, 1, addr lidos, NULL

sub entrada, 48

invoke atodw, addr entrada
pop ebx
push 1
push 3
push 2
push entrada


call hanoi
add esp, 16


invoke GetStdHandle, STD_OUTPUT_HANDLE
mov handle_out, eax

mov ebx, 126
push -1

empilha:
push array[ebx*4]
dec ebx

cmp ebx, 0
jg empilha





imprime:

pop peguei



;mov peguei, ebx

cmp peguei, -1
je encerra

cmp peguei, 0
je imprime
invoke dwtoa, peguei, addr string_covert


invoke StrLen, addr string_covert
mov tam_string, eax

invoke WriteConsole, handle_out, addr string_covert, tam_string, addr cara_escrito, NULL
inc cont

invoke StrLen, addr espaco
mov tam_string, eax

invoke WriteConsole, handle_out, addr espaco, tam_string, addr cara_escrito, NULL





cmp cont, 2
jne imprime

invoke StrLen, addr pulei
mov tam_string, eax

invoke WriteConsole, handle_out, addr pulei, tam_string, addr cara_escrito, NULL

mov cont, 0


cmp peguei, -1
jg imprime


encerra:

invoke ExitProcess, 0
end start