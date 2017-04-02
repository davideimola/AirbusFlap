.section .data

car:
    .byte 0
.section .text
	.global siconverter
	.type siconverter, @function

# Parmetri di ingresso: nessuno
# Parametro d'uscita: %eax

siconverter:
    movl $0,car
	xorl %eax,%eax

	inizio:
		pushl %eax
 		movl  $3,%eax           # carica in eax il codice della chiamata di sistema read
  		movl  $0,%ebx           # azzera ebx (0=tastiera)
  		leal  car,%ecx          # carica in ecx l'indirizzo di car in cui verra' salvato il carattere letto
  		mov   $1,%edx           # comanda di leggere un solo carattere
  		int   $0x80             # chiamata di sistema
  		popl %eax
  		cmp   $10,car           # vedo se e' stato letto il carattere '\n'
  		je    fine

 		subb  $48,car           # converte il codice ASCII della cifra nel numero corrisp.
  		movl  $10,%ebx
  		mull  %ebx              # eax = eax * 10 + car
  		addl  car, %eax 
  		# sto trascurando i 32 bit piu' significativi del risultato 
  		# della moltiplicazione che sono in edx 
  		# quindi il numero introdotto da tastiera deve essere minore di 2^32
  		jmp   inizio

  	fine:
  		ret                     # il valore è già in eax

