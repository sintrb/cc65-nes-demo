del runtime\*.o
del sinnes\*.o
cd runtime
for %%f in (*.s) do ca65 -t nes %%f
cd ..
cd sinnes
for %%f in (*.s) do ca65 -t nes %%f
cd ..
del *.lib
ar65 a sinnes.lib runtime\*.o
ar65 a sinnes.lib sinnes\*.o
ar65 l sinnes.lib >sinneslist.txt
pause