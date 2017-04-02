.section .data

nParametri:
    .byte 0

failcount:
	.long 0


error_message:
	.ascii "Codice errato, inserire nuovamente il codice " #Stringa costante di errore.

error_message_len:
	.long . - error_message #Lunghezza stringa in byte.


.section .text
	.global _start

# Nel programma lo stack si presenta così: (n, ... , n1, n0), ISTR., nParametri
_start:
    # Estraggo il numero di parametri e controllo che sia pari a 4 (nome del programma e 3 parametri).
    
    movl $0,failcount

	popl %eax
	movl %eax,nParametri
    movl $4,%edx
	cmpl nParametri,%edx
	jne failure                         # Se non vi sono 3 parametri salto.

	#jne true
	popl %eax                           # Estraggo il nome del programma, non serve per lo svolgimento del programma
    
    xorl %eax,%eax                      #
    xorl %ebx,%ebx                      # Azzero i registri
    xorl %ecx,%ecx                      #

    popl %edx                           #
    mov (%edx),%al                      # Estraggo i tre parametri e
    popl %edx                           # li salvo nella parte meno
    mov (%edx),%bl                      # significativa dei registri
    popl %edx                           #
    mov (%edx),%cl                      #

    subb $48,%al                        #
    subb $48,%bl                        # Converto da stringa ad intero
    subb $48,%cl                        #

	call control
	cmpl $1,%eax                        # Controllo se il programma entra in modalità dinamica
	je dinamic_label
	cmpl $2,%eax                        # Controllo se il programma entra in modalità di emergenza
	je emergence_label
	jmp failure

	#jne false
	failure:
		incl failcount
        movl $3,%edx
		cmpl failcount,%edx             # Controllo se il programma entra in modalità safe
		je safe_label

		#System call write()
		movl $4,%eax
		movl $1,%ebx
		leal error_message,%ecx
		movl error_message_len,%edx
		int $0x80

		call siinputc                   # Chiamata per il reinserimento dei parametri
		call control

		cmpl $1,%eax
		je dinamic_label
		cmpl $2,%eax
		je emergence_label
		jmp failure

	emergence_label:
		#Inserimento Emergenza
		call emergence
		jmp endprogram


	dinamic_label:
		#Inserimento Dinamico
		call dinamic
		jmp endprogram


	safe_label:
        #Inserimento Safe.
		call safe
		jmp endprogram

	endprogram:
		movl $1,%eax                    #Mette a 1 il registro EAX, 1 è il codice della system call exit
		movl $0,%ebx                    #Azzera EBX. Contiene il codice di ritorno della exit.
    	int $0x80                       #Esegue la system call exit

