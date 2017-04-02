EXE= flap
AS= as 
LD= ld 
FLAGAS= --32 -gstabs 
FLAGLD= -melf_i386 
OBJ=control.o dinamic.o emergence.o main.o siconverter.o siinputc.o safe.o itoa.o

$(EXE): $(OBJ)
	$(LD) $(FLAGLD) -o $(EXE) $(OBJ)
control.o: control.s
	$(AS) $(FLAGAS) -o control.o control.s
dinamic.o: dinamic.s
	$(AS) $(FLAGAS) -o dinamic.o dinamic.s
emergence.o: emergence.s
	$(AS) $(FLAGAS) -o emergence.o emergence.s
main.o: main.s
	$(AS) $(FLAGAS) -o main.o main.s
siconverter.o: siconverter.s
	$(AS) $(FLAGAS) -o siconverter.o siconverter.s
siinputc.o: siinputc.s
	$(AS) $(FLAGAS) -o siinputc.o siinputc.s
safe.o: safe.s
	$(AS) $(FLAGAS) -o safe.o safe.s
itoa.o: itoa.s
	$(AS) $(FLAGAS) -o itoa.o itoa.s
clean:
	rm -f *.o $(EXE) core
