.section .data

num1:
	.long 0

num2:
  .long 0

count:
  .long 0

car:
    .long 0

.section .text
	.global siinputc
	.type siinputc, @function

# Parametri di ingresso: nessuno
# Parametri d'uscita: %eax, %ebx, %ecx

siinputc:
    movl $0,car
	movl $0,%eax
    movl $0,count

	inizio:
		pushl %eax

 		movl  $3,%eax               # carica in eax il codice della chiamata di sistema read
  	    movl  $0,%ebx               # azzera ebx (0 = tastiera)
  	    leal  car,%ecx              # carica in ecx l'indirizzo di car in cui verra' salvato il carattere letto
  	    mov   $1,%edx               # comanda di leggere un solo carattere
  	    int   $0x80                 # chiamata di sistema

  	    popl %eax

  	    cmp   $32,car               # vedo se e' stato letto il carattere spazio
  	    je    passaggio
        cmp   $10,car               # vedo se è stato letto il carattere Enter
        je    end

 	    subb  $48,car               # converte il codice ASCII della cifra nel numero corrisp.
        movl  $10,%ebx
  	    mull  %ebx                  #
  	    addl  car, %eax             # eax = eax * 10 + car

  	    # sto trascurando i 32 bit piu' significativi del risultato 
  	    # della moltiplicazione che sono in edx 
  	    # quindi il numero introdotto da tastiera deve essere minore di 2^32
  	    jmp   inizio

    primo:                          #
      movl %eax,num1                # Salva il primo dei tre
      movl $0,%eax                  # valori inseriti
      jmp inizio                    #

    secondo:                        #
      movl %eax,num2                # Salva il secondo dei tre
      movl $0,%eax                  # valori inseriri
      jmp inizio                    #

  	passaggio:                      #
        incl count                  # La funzione dopo aver letto uno spazio
        cmpl $1,count               # controlla quanti valori sono già stati trovati
        je primo                    # e decide in che variabile inserisce
        cmpl $2,count               # il nuovo valore
        je secondo                  #
        jmp fine_lettura
    
    end:
  		movl %eax,%ecx              #
        movl num2,%ebx              # Mette i valori nei registri preposti
        movl num1,%eax              # per l'uscita della funzione

        ret

    fine_lettura:

 		movl  $3,%eax               # carica in eax il codice della chiamata di sistema read
  	    movl  $0,%ebx               # azzera ebx (0 = tastiera)
  	    leal  car,%ecx              # carica in ecx l'indirizzo di car in cui verra' salvato il carattere letto
  	    mov   $1,%edx               # comanda di leggere un solo carattere
  	    int   $0x80                 # chiamata di sistema

        cmp   $10,car               # vedo se è stato letto il carattere Enter
        je    errore
        jmp fine_lettura

    errore:
        movl $50,%ecx             #
        movl $0,%ebx              # Mette i valori nei registri preposti
        movl $0,%eax              # per l'uscita della funzione

        ret


