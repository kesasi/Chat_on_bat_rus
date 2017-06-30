:: Добавлена регистрация и вход
:: Добавлены команды /exit /name по желанию можно добавить
:: При использовании сменить кодировку на OEM-866
@echo off
color F0
cls
pushd "%~dp0"
if "%~1" == "talk_widget" goto talker
:auth
echo Создать новый индификатор или подключиться к уже существующему^?
echo ________________________________________________________________
echo.
echo 1 ^| Подключиться к чату ^| 
echo 2 ^| Создать ^|  
set /p var="> "
echo.

if %var% equ 1 goto first
if %var% equ 2 goto second

cls
echo "%var%" неправильный ответ.
echo.
goto auth

:second
cls
echo Создать чат или аккаунт^?
echo _________________________
echo.
echo 1 ^| Аккаунт ^| 
echo 2 ^| Чат ^|
set /p var="> "
echo.

if %var% equ 1 goto one
if %var% equ 2 goto second

cls
echo "%var%" неправильный ответ.
echo.
goto auth

:one
cls
echo Никнейм:
set /p nickname=^> 
if EXIST assets\%nickname%_name.dll (cls & echo Такой пользователь уже существует. & echo _________________________________ & ping -n 3 localhost > Nul & cls & goto auth ) ELSE cls & goto m54
:m54
echo Установите пароль на аккаунт.
set /p passw=^>
cls
echo Успешно создан!
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
echo Имя чата:
set /p chat=^> 
IF EXIST assets\IND_%chat% (cls & echo Такой чат уже существует. & echo __________________________ & ping -n 3 localhost > Nul & cls & goto auth) ELSE echo Успешно! & echo ___________ & ping -n 3 localhost > Nul & cls
echo Введите ваш ник: 
set /p nick=^> 
md assets\IND_%chat%
set /a 1+5*%random%/32768
echo %chat%%random%>> assets\IND_%chat%\ind_%chat%.dll
echo %nick%>> assets\IND_%chat%\admins.dll 
set /p info=< assets\IND_%chat%\ind_%chat%.dll
cls
echo Ваш индификатор, запомните или запишите его: %info% (закроется через 10 сек.) & ping -n 11 localhost > Nul & cls & goto auth


:first
cls
echo Логин:
set /p login=^> 
if EXIST assets\%login%_name.dll (cls & echo Успешно! & echo ____________ & ping -n 3 localhost > Nul & cls) else cls & Echo Такого аккаунта нет, зарегистрируйтесь. & echo ______________________________________ & ping -n 3 localhost > Nul & cls & goto auth
echo Введите имя сети:
set /p chat=^>
echo Введите индификатор:
set /p indef=^>
set nick=%login%
IF EXIST assets\IND_%chat% (goto three) else (cls & echo Такого чата не существует, выберите 2 пункт из меню. & echo ____________________________________________________ & goto auth)
cls
echo Такого чата не существует, выберите 2 пункт из меню.
echo ____________________________________________________
ping -n 5 localhost > Nul
goto auth

:three
set /p comment1=< assets\IND_%chat%\admins.dll
set /p pass=< assets\%login%_pass.dll
if %nick%==%comment1% echo Введите пароль: & set /p pas1=^> & goto me4
set /p comment=< assets\IND_%chat%\ind_%chat%.dll
if %indef%==%comment% (cls & echo Принято & echo ___________ & goto m3) else cls & echo Неправильное имя чата или индификатор. & echo ______________________________________ & ping -n 3 localhost > Nul & goto auth
:me4
if %pas1%==%pass% (cls & echo Доступ получен! & echo _______________ & ping -n 3 localhost > Nul & cls & goto m3) else cls & echo Доступ запрещён! & echo _______________ & ping -n 3 localhost > Nul & cls & goto auth

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
echo (%TIME% %nick% присоединился)>lib\%chat%
call ::cs_out
echo (%TIME% %nick% присоединился)>>lib\%chat%_history
:talker_loop
cls
echo Ввод:
set /p msg=^>
set msg=%msg:&=%
set msg=%msg:[=%
set msg=%msg:]=%
set msg=%msg:>=%
set msg=%msg:<=%
set mds=%msg%
set mds=%mds: =%
if %mds%==/exit (echo ^(%TIME% %nick% вышел^) & exit exitCode )>lib\%chat%
if %mds%==/exit (echo ^(%TIME% %nick% вышел^) & exit exitCode )>>lib\%chat%_history
if %mds%==/boobs (set msg=^(.^)^(.^))>lib\%chat%
if %mds%==/boobs (set msg=^(.^)^(.^))>lib\%chat%_history
if %mds%==/name (set /p nick="")>lib\%chat%
if %mds%==/name (set msg=сменил имя на %nick%)>lib\%chat%_history
call ::cs_in
set /p nc=< assets\IND_%chat%\admins.dll
if %nick%==%nc% (echo Админ_[%TIME% %nick%]: %msg%>lib\%chat%) else echo [%TIME% %nick%]: %msg%>lib\%chat%
call ::cs_out
if %nick%==%nc% (echo Админ_[%TIME% %nick%]: %msg%>>lib\%chat%_history) else echo [%TIME% %nick%]: %msg%>>lib\%chat%_history
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
