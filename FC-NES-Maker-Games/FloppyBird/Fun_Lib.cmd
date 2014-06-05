@echo off
echo %1 是操作符号
Echo %2 是软件根目录
echo %3 是库文件名
echo %4 是模块文件名


set myDir=%2
set myDir=%myDir:"=%

::echo %myDir%

set CC65_HOME=%myDir%_APP\_cc65
set Path=%myDir%_APP\_cc65\bin

Echo CC65_HOME=%CC65_HOME%
Echo Path=%Path%

if '%1'=='-v' goto :View
if '%1'=='-a' goto :Add
if '%1'=='-d' goto :Del
if '%1'=='-g' goto :Get

goto :End


:View
del Lib.lst
ar65 l %3>>Lib.lst
goto :End

:Add
ar65 a %3 %4
del Lib.lst
ar65 l %3>>Lib.lst
goto :End

:Del
ar65 d %3 %4
del Lib.lst
ar65 l %3>>Lib.lst
goto :End

:Get
ar65 x %3 %4
goto :End

:Pau
pause
:End