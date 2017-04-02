.section .data

safe_mess:
	.ascii "\nControllo codice errato! Modalità Safe inserita!\n\n"

safe_mess_len:
	.long . - safe_mess
	
.section .text
	.global safe
	.type safe, @function

safe:
	movl $4,%eax                #
	movl $1,%ebx                # Stampa ingresso in modalità
	leal safe_mess,%ecx         # Safe
	movl safe_mess_len,%edx     #
	int $0x80                   #

    ret

