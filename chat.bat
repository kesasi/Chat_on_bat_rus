@echo off
color F0
cls
pushd "%~dp0"
if "%~1" == "talk_widget" goto talker
@echo off
:auth
echo ������� ���� ����䨪��� ��� ����������� � 㦥 �������饬�^?
echo ________________________________________________________________
echo.
echo 1 ^| ����������� � ��� ^| 
echo 2 ^| ������� ^|  
set /p var="> "
echo.

if %var% equ 1 goto first
if %var% equ 2 goto second

cls
echo "%var%" ���ࠢ���� �⢥�.
echo.
goto auth

:second
cls
echo ������� �� ��� ������^?
echo _________________________
echo.
echo 1 ^| ������ ^| 
echo 2 ^| ��� ^|
set /p var="> "
echo.

if %var% equ 1 goto one
if %var% equ 2 goto second

cls
echo "%var%" ���ࠢ���� �⢥�.
echo.
goto auth

:one
cls
echo �������:
set /p nickname=^> 
if EXIST assets\%nickname%_name.dll (cls & echo ����� ���짮��⥫� 㦥 �������. & echo _________________________________ & ping -n 3 localhost > Nul & cls & goto auth ) ELSE cls & goto m54
:m54
echo ��⠭���� ��஫� �� ������.
set /p passw=^>
cls
echo �ᯥ譮 ᮧ���!
echo _______________
ping -n 3 localhost > Nul
cls
md assets
echo %passw%>> assets\%nickname%_pass.dll
echo %nickname%>> assets\%nickname%_name.dll
set /p name=< assets\%nickname%_name.dll 
goto auth

:second
cls
echo ��� ��:
set /p chat=^> 
IF EXIST assets\IND_%chat% (cls & echo ����� �� 㦥 �������. & echo __________________________ & ping -n 3 localhost > Nul & cls & goto auth) ELSE echo �ᯥ譮! & echo ___________ & ping -n 3 localhost > Nul & cls
echo ������ ��� ���: 
set /p nick=^> 
md assets\IND_%chat%
set /a 1+5*%random%/32768
echo %chat%%random%>> assets\IND_%chat%\ind_%chat%.dll
echo %nick%>> assets\IND_%chat%\admins.dll 
set /p info=< assets\IND_%chat%\ind_%chat%.dll
cls
echo ��� ����䨪���, �������� ��� ������ ���: %info% (���஥��� �१ 10 ᥪ.) & ping -n 11 localhost > Nul & cls & goto auth


:first
cls
echo �����:
set /p login=^> 
if EXIST assets\%login%_name.dll (cls & echo �ᯥ譮! & echo ____________ & ping -n 3 localhost > Nul & cls) else cls & Echo ������ ������ ���, ��ॣ���������. & echo ______________________________________ & ping -n 3 localhost > Nul & cls & goto auth
echo ������ ��� ��:
set /p chat=^>
echo ������ ����䨪���:
set /p indef=^>
set nick=%login%
IF EXIST assets\IND_%chat% (goto three) else (cls & echo ������ �� �� �������, �롥�� 2 �㭪� �� ����. & echo ____________________________________________________ & goto auth)
cls
echo ������ �� �� �������, �롥�� 2 �㭪� �� ����.
echo ____________________________________________________
ping -n 5 localhost > Nul
goto auth

:three
set /p comment1=< assets\IND_%chat%\admins.dll
set /p pass=< assets\%login%_pass.dll
if %nick%==%comment1% echo ������ ��஫�: & set /p pas1=^> & goto me4
set /p comment=< assets\IND_%chat%\ind_%chat%.dll
if %indef%==%comment% (cls & echo �ਭ�� & echo ___________ & goto m3) else cls & echo ���ࠢ��쭮� ��� �� ��� ����䨪���. & echo ______________________________________ & ping -n 3 localhost > Nul & goto auth
:me4
if %pas1%==%pass% (cls & echo ����� ����祭! & echo _______________ & ping -n 3 localhost > Nul & cls & goto m3) else cls & echo ����� ������! & echo _______________ & ping -n 3 localhost > Nul & cls & goto auth

:m3
md lib
start call %0 talk_widget %chat% %nick%
:listener
cls
call title "| Chat: %chat% | User: %nick% |"
if exist lib\%chat%_history type lib\%chat%_history
if not exist lib\%chat% echo. 2>lib\%chat%
:listener_loop
ping 127.0.0.1 -n 1 -w 20 > nul
set oldtext=%text%
set /p text=<lib\%chat%
if not "%text%" == "%oldtext%" echo %text%
goto listener_loop
:talker
set chat=%~2
set nick=%~3
cls
call title "| Chat: %chat% | User: %nick% |"
call ::cs_in
echo (%TIME% %nick% ��ᮥ�������)>lib\%chat%
call ::cs_out
echo (%TIME% %nick% ��ᮥ�������)>>lib\%chat%_history
:talker_loop
cls
echo ����:
set /p msg=^>
set msg=%msg:&=%
set msg=%msg:[=%
set msg=%msg:]=%
set msg=%msg:>=%
set msg=%msg:<=%
set mds=%msg%
set mds=%mds: =%
if %mds%==/exit (echo ^(%TIME% %nick% ��襫^) & exit exitCode )>lib\%chat%
if %mds%==/exit (echo ^(%TIME% %nick% ��襫^) & exit exitCode )>>lib\%chat%_history
if %mds%==/boobs (set msg=^(.^)^(.^))>lib\%chat%
if %mds%==/boobs (set msg=^(.^)^(.^))>lib\%chat%_history
if %mds%==/name (set /p nick="")>lib\%chat%
if %mds%==/name (set msg=ᬥ��� ��� �� %nick%)>lib\%chat%_history
call ::cs_in
set /p nc=< assets\IND_%chat%\admins.dll
if %nick%==%nc% (echo �����_[%TIME% %nick%]: %msg%>lib\%chat%) else echo [%TIME% %nick%]: %msg%>lib\%chat%
call ::cs_out
if %nick%==%nc% (echo �����_[%TIME% %nick%]: %msg%>>lib\%chat%_history) else echo [%TIME% %nick%]: %msg%>>lib\%chat%_history
goto talker_loop
:cs_in
if exist "lib\%chat%_cs" ping 127.0.0.1 -n 1 -w 50 > nul
set cs_value=%RANDOM%
:cs_in_loop
echo %cs_value%>lib\%chat%_cs
set /p ret=<lib\%chat%_cs
if "%ret%" == "%cs_value%" exit /b
ping 127.0.0.1 -n 1 -w 10 > nul
goto :cs_in_loop
:cs_out
del lib\%chat%_cs
exit /b
del "%~f0"
