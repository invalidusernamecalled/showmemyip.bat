@setlocal enabledelayedexpansion & echo off

call :setcolor

:loop
set /a index=-1
for /l %%i in (1,1,2) do echo:

for /f "delims=" %%i in ("*") do echo:                                     %green%?? My ip address.. Retrieveing........%reset%
for /f "delims=" %%i in ('curl ipecho.net/plain 2^>NUL') do set ext_ip=%%i
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| find "IPv4 Address"') do (
set /a index+=1
set ipv4[!index!]=%%i
)
Cls

for /l %%i in (1,1,10) do echo:
echo:                                            - == i.p. mate == -
for /l %%a in (0,1,!index!) do echo:                                    %%a^> My ip address: !ipv4[%%a]!
set /a ext_number=index+1
echo: 
echo                                     %ext_number%^> EXTERNAL I.P :  %red%%ext_ip%%reset%
echo:
call :construct_args
echo:                                        [R]efresh          [!args!]
:choose
choice /c !args!zr  /n /d z /t 3 >NUL
set errors=%errorlevel%
:chooseagainchooser
set /a whatpick=errors-1
if %whatpick% Lss %ext_number% CALL echo %%ipv4[%whatpick%]%% | clip & echo                                         Copied ^^^!
if %whatpick% Lss 0 echo|set/p=.                                         wrong&goto choose
if %whatpick% == %ext_number% echo %ext_ip% | clip & echo                                         Copied ^^^!
if %whatpick%==%z_number% goto choose
REM for /l %%i in (1,1,4) do echo:
if %whatpick%==%r_number% goto loop
goto choose
:setcolor
set red=[101;93m
set green= [32m
set reset= [0m

exit /b

:construct_args
set args=
for /l %%i in (0,1,!index!) do set args=!args!%%i&echo: >NUL
set args=!args!%ext_number%
set /a z_number=ext_number+1
set /a r_number=ext_number+2

:::::::::::::::::::::::::::::::::this section does not contain any code:::
:::::::::::::::::::::::::::::::::this section does not contain any code###
:------::::::::::::::::::::::::this section does not contain any code#####
:----------- script whatismyip.bat -------- author: u/Sudden-March-3952##:

: External websites used
:$ can be replaced by
:$ curl -4 icanhazip.com
:$ curl -6 icanhazip.com
:$ curl ifconfig.me
:$ curl api.ipify.org
:$ curl bot.whatismyipaddress.com
:$ curl ipinfo.io/ip
:$ curl ipecho.net/plain
: 
