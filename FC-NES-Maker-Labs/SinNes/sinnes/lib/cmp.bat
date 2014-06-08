del *.o
ca65 -t nes nes.s
ar65 d nes.lib nes.o
ar65 a nes.lib nes.o
pause