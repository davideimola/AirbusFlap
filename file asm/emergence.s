.section .data

emergence_mess:
	.ascii "\nModalità controllo emergenza inserita.\n\n"

emergence_mess_len:
	.long . - emergence_mess
	
.section .text
	.global emergence
	.type emergence, @function

emergence:
	movl $4,%eax                    #
	movl $1,%ebx                    # Stampa ingresso in modalità
	leal emergence_mess,%ecx        # emergenza
	movl emergence_mess_len,%edx    #
    int $0x80                       #

    ret

