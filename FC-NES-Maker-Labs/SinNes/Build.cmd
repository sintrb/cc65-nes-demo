@Echo off
Echo %1 是软件根目录
Echo %2 是工程名称

set myDir=%1
set myDir=%myDir:"=%
set mypj=%2
set mypj=%mypj:"=%
set Path=%myDir%_APP\_cc65\bin

Echo Path=%Path%
REM goto start 
echo 准备sinnes.lib
cd sinnes\lib\

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

cd ..
cd ..
:start
copy sinnes\lib\sinnes.lib .\nes.lib
copy sinnes\lib\sinnes\nes.inc .\nes.inc
copy sinnes\lib\sinnes\zeropage.inc .\zeropage.inc
copy sinnes\include\sinnes.h .\sinnes.h

echo 准备sinnes.lib完毕



Echo .
Echo 第一步，删除模块与NES
del *.o
del *.nes
ar65 d nes.lib ctr0.o

Echo .
Echo 第二步，编译加插的模块，并添加到库
ca65 -t nes ctr0.s
ar65 a nes.lib ctr0.o

Echo .
Echo 第三步，编译C，并连接库，生成nes
echo on
cl65 -C nes.cfg -t nes -o "%mypj%.nes" HelloWorld.c

@Echo off
Echo .
pause