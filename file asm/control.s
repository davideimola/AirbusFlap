.section .data

x:
    .long 0
y:
    .long 0
z:
    .long 0

.section .text
	.global control
	.type control, @function

#Ritorno dello Stack dei codici per capire il risultato del controllo.
#0 CODICE ERRATO
#1 CODICE DINAMICO (3 3 2)
#2 CODICE EMERGENZA (9 9 2)

# Parmetri di ingresso: %eax, %ebx, %ecx
# Parametro d'uscita: %eax

control:

	movl %eax,x
    movl %ebx,y
    movl %ecx,z

	#Controllo correttezza codice inserito
    movl $2,%ebx
	cmpl z,%ebx
	jne error
    movl $3,%ebx
	cmpl y,%ebx
	je dinamic_code
    movl $9,%ebx
	cmpl y,%ebx
	je emergence_code
	jmp error

	dinamic_code:
        movl $3,%ebx
		cmpl x,%ebx
		je dinamic
		jmp error

	emergence_code:
        movl $9,%ebx
		cmpl x,%ebx
		je emergence
		jmp error

	dinamic:
		movl $1,%eax
		jmp end

	emergence:
		movl $2,%eax
		jmp end

	error:
		movl $0,%eax
	
	end:
        ret

