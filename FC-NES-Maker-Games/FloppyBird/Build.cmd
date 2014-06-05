@Echo off
Echo %1 是软件根目录
Echo %2 是工程名称

set myDir=%1
set myDir=%myDir:"=%

set mypj=%2
set mypj=%mypj:"=%

set CC65_HOME=%myDir%_APP\_cc65
set Path=%myDir%_APP\_cc65\bin

Echo CC65_HOME=%CC65_HOME%
Echo Path=%Path%

Echo .
Echo 第一步，删除模块与NES
del *.o
del *.nes
ar65 d nes.lib crt0.o

Echo .
Echo 第二步，编译加插的模块，并添加到库
ca65 -t nes crt0.s
ar65 a nes.lib crt0.o

Echo .
Echo 第三步，编译C，并连接库，生成nes
echo on
cl65 -C nes.cfg -t nes -o "%mypj%.nes" -I "%CC65_HOME%\include" Main.c

@Echo off
Echo .
pause