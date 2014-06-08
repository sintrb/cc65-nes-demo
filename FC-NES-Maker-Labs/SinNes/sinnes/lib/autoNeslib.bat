del sinnes\*.o
cd sinnes
for %%f in (*.s) do ca65 -t nes %%f
ar65 d ..\nes.lib *.o
ar65 a ..\nes.lib *.o
cd ..
ar65 l nes.lib >sinneslist.txt
pause