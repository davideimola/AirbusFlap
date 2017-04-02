.section .data

dinamic_mess:
	.ascii "\nModalità controllo dinamico inserita.\n\n"

dinamic_mess_len:
	.long . - dinamic_mess

dinamic_err:
	.ascii "\nLa somma totale di passeggeri per fila é diversa da quella totale precedentemente inserita.\n\n"

dinamic_err_len:
	.long . - dinamic_err

dinamic_pass:
	.ascii "\nInserire il numero totale di passeggeri a bordo: "

dinamic_pass_len:
	.long . - dinamic_pass

dinamic_abc:
	.ascii "\nInserire il numero totale di passeggeri per le file A,B e C: "

dinamic_abc_len:
	.long . - dinamic_abc

dinamic_def:
	.ascii "\nInserire il numero totale di passeggeri per le file D,E e F: "

dinamic_def_len:
	.long . - dinamic_def

dinamic_stmp:
	.ascii "\nI valori dei 4 bias sono:\n"

dinamic_stmp_len:
	.long . - dinamic_stmp

negative_sign:
	.ascii "-"

negative_sign_len:
	.long . - negative_sign


tmp:
    .long 0

x:
    .long 0
y:
    .long 0
z:
    .long 0

k1:
    .long 0
k2:
    .long 0
k3:
    .long 0

nA:
    .long 0
nB:
    .long 0
nC:
    .long 0
nD:
    .long 0
nE:
    .long 0
nF:
    .long 0

flap1:
    .long 0
flap2:
    .long 0
flap3:
    .long 0
flap4:
    .long 0

passeggeri:
    .byte 0

.section .text
	.global dinamic
	.type dinamic, @function

# Parmetri di ingresso: nessuno
# Parametro d'uscita: nessuno

dinamic:

	movl $4,%eax                    #
	movl $1,%ebx                    #
	leal dinamic_mess,%ecx          # Stampa a video l'entrata in modalità dinamica
	movl dinamic_mess_len,%edx      #
	int $0x80                       #

	#Richiesta inserimento totale passeggeri!
	inizio:

		movl $4,%eax                #
		movl $1,%ebx                #
		leal dinamic_pass,%ecx      # Richiesta inserimento totale passeggeri
		movl dinamic_pass_len,%edx  #
		int $0x80                   #

		call siconverter
        movl $180,%edx
  		cmpl %edx,%eax              # Il numero di passeggeri non superare il 180
  		jg inizio
        movl $0,%edx
  		cmpl %edx,%eax              # Il numero di passeggeri non può essere inferiore di 0
  		jl inizio

  		movl %eax,passeggeri
        
  		movl $4,%eax                #
		movl $1,%ebx                #
		leal dinamic_abc,%ecx       # Richiede i valori delle sezioni A,B,C
		movl dinamic_abc_len,%edx   #
		int $0x80                   #

		call siinputc
        movl $30,%edx               #
        cmpl %edx,%eax              #
        jg inizio                   # Controllo che i passeggeri nelle file
        cmpl %edx,%ebx              # non siano maggiori di 30
        jg inizio                   #
        cmpl %edx,%ecx              #
        jg inizio                   #

        movl $0,%edx                #
        cmpl %edx,%eax              #
        jl inizio                   # Controllo che i passegeri nelle file
        cmpl %edx,%ebx              # non siano minori di 0
        jl inizio                   #
        cmpl %edx,%ecx              #
        jl inizio                   #

        movl %eax, nA               #
        movl %ebx, nB               # Salvataggio passeggeri per file
        movl %ecx, nC               #

  		movl $4,%eax                #
		movl $1,%ebx                #
		leal dinamic_def,%ecx       # Richiede i valori delle sezioni D,E,F
		movl dinamic_def_len,%edx   #
		int $0x80                   #

		call siinputc
        movl $30,%edx               #
        cmpl %edx,%eax              #
        jg inizio                   # Controllo che i passeggeri nelle file
        cmpl %edx,%ebx              # non siano maggiori di 30
        jg inizio                   #
        cmpl %edx,%ecx              #
        jg inizio                   #

        movl $0,%edx                #
        cmpl %edx,%eax              #
        jl inizio                   # Controllo che i passegeri nelle file
        cmpl %edx,%ebx              # non siano minori di 0
        jl inizio                   #
        cmpl %edx,%ecx              #
        jl inizio                   #

		movl %eax, nD               #
        movl %ebx, nE               # Salvataggio passeggeri per file
        movl %ecx, nF               #

		movl nA,%ebx                #
		addl nB,%ebx                # Effettuo la somma di tutte le variabili,
		addl nC,%ebx                # controllo che la loro somma sia uguale
		addl nD,%ebx                # al numero totale di passeggeri
		addl nE,%ebx                #
		addl nF,%ebx                #
                                    #
		cmpl passeggeri,%ebx        #
		je calcoli                  #

		movl $4,%eax                #
		movl $1,%ebx                #
		leal dinamic_err,%ecx       # Stampa un messaggio di errore, i passeggeri totali
		movl dinamic_err_len,%edx   # non corrispondono ai valori delle somme delle file
		int $0x80                   #
		jmp inizio

		calcoli:
			movl nA,%ebx
			subl nF,%ebx
			movl %ebx,x

			movl nB,%ebx
			subl nE,%ebx
			movl %ebx,y

			movl nC,%ebx
			subl nD,%ebx
			movl %ebx,z

			movl $3,k1
			movl $6,k2
			movl $12,k3

			#Flap 1
			movl x,%eax
			imull k1                # eax = x*k1
            movl $2, %ecx
			idivl %ecx              # eax = eax/2
			addl %edx,%eax          #Arrotondo per eccesso.
			movl %eax,%ebx          #Salvo il valore

			movl y,%eax
			imull k2                # eax = y*k2
            movl $2, %ecx
			idivl %ecx              # eax = eax/2
			addl %edx,%eax          #Arrotondo per eccesso.
			addl %eax,%ebx          #Somma finale
			movl %ebx,flap1

			#Flap 2
			movl y,%eax
			imull k2
            movl $2, %ecx
			idivl %ecx
			addl %edx,%eax
			movl %eax,%ebx 

			movl z,%eax
			imull k3 
			movl $2, %ecx
			idivl %ecx 
			addl %edx,%eax
			addl %eax,%ebx 
			movl %ebx,flap2

			#Flap 3
			movl y,%eax
			imull k2                # eax = eax*k2
			movl $2, %ecx
			idivl %ecx              # eax = eax/2
			addl %edx,%eax          #Arrotondo per eccesso.
			movl $0,%ebx
			subl %eax,%ebx          #Inverto il segno.

			movl z,%eax
			imull k3 
			movl $2, %ecx
			idivl %ecx 
			addl %edx,%eax 
			movl $0,%ecx
			subl %eax,%ecx          #Inverto il segno.
			addl %ecx,%ebx
			movl %ebx,flap3

			#Flap 4
			movl x,%eax
			imull k1
			movl $2, %ecx
			idivl %ecx
			addl %edx,%eax 
			movl $0,%ebx
			subl %eax,%ebx

			movl y,%eax
			imull k2 
			movl $2, %ecx
			idivl %ecx
			addl %edx,%eax 
			movl $0,%ecx
			subl %eax,%ecx 
			addl %ecx,%ebx
			movl %ebx,flap4

			#Stampo i valori
			movl $4,%eax
			movl $1,%ebx
			leal dinamic_stmp,%ecx
			movl dinamic_stmp_len,%edx
			int $0x80

            # In ogni blocco controllo che il segno sia positivo, in caso contrario
            # inverto il segno e stampo a schermo il segno.
            # La funzione "itoa" si occupa di stampare solamente valori senza segno.
            
            movl flap1,%eax         #
            movl $0,%ebx            #
            cmpl %eax,%ebx          #
            jg inverti_flap1        # 
            itoa1:                  #
                call itoa           #

            movl flap2,%eax         #
            movl $0,%ebx            #
            cmpl %eax,%ebx          #
            jg inverti_flap2        #
            itoa2:                  #
                call itoa           #

            movl flap3,%eax         #
            movl $0,%ebx            #
            cmpl %eax,%ebx          #
            jg inverti_flap3        #
            itoa3:                  #
                call itoa           #

            movl flap4,%eax         #
            movl $0,%ebx            #
            cmpl %eax,%ebx          #
            jg inverti_flap4        #
            itoa4:                  #
                call itoa           #
    
            jmp end
            

            inverti_flap1:
                movl $0,%ecx
			    subl %eax,%ecx
                movl %ecx,tmp

                movl $4,%eax
			    movl $1,%ebx
			    leal negative_sign,%ecx
			    movl negative_sign_len,%edx
			    int $0x80

                movl tmp,%eax
                jmp itoa1

            inverti_flap2:
                movl $0,%ecx
			    subl %eax,%ecx
                movl %ecx,tmp

                movl $4,%eax
			    movl $1,%ebx
			    leal negative_sign,%ecx
			    movl negative_sign_len,%edx
			    int $0x80

                movl tmp,%eax
                jmp itoa2

            inverti_flap3:
                movl $0,%ecx
			    subl %eax,%ecx
                movl %ecx,tmp

                movl $4,%eax
			    movl $1,%ebx
			    leal negative_sign,%ecx
			    movl negative_sign_len,%edx
			    int $0x80

                movl tmp,%eax
                jmp itoa3

            inverti_flap4:
                movl $0,%ecx
			    subl %eax,%ecx
                movl %ecx,tmp

                movl $4,%eax
			    movl $1,%ebx
			    leal negative_sign,%ecx
			    movl negative_sign_len,%edx
			    int $0x80

                movl tmp,%eax
                jmp itoa4



            end:
                ret

