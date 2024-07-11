@setlocal enabledelayedexpansion & echo off

set websites="curl -4 icanhazip.com" "curl -6 icanhazip.com" "curl ifconfig.me" "curl api.ipify.org" "curl bot.whatismyipaddress.com" "curl ipinfo.io/ip" "curl ipecho.net/plain"
set gateways="192.168.1.1"
set pingdomains="google.com" "yahoo.com" "twitter.com" "youtube.com"




set website_index=7



if exist "%tmp%\whatismyip.config.client.conf" for /f "delims=" %%i in ('type "%tmp%\whatismyip.config.client.conf"') do set website_index=%%i&set add_options=/d g /t 1



set total_index=7





:begin
cls
echo:Select Client:
echo:
set index_search=0
for %%a in (%websites%) do (
set /a index_search+=1
if !index_search! == %website_index% (echo:          ^>%%~a&set website=%%~a) else (echo:           %%~a)
)
choice /c xzg /m "z=up x=down [G]o" /n %add_options%
set add_options=/d g /t 20
if %errorlevel%==3 goto next
if %errorlevel%==1 (set /a website_index+=1) else (set /a website_index-=1)
if %website_index% GTR %total_index% set /a website_index=7
if %website_index% LSS 1   set /a website_index=1
goto begin
:next
echo %website_index% >"%tmp%\whatismyip.config.client.conf"
call :setcolor
:loop
set /a index=-1

for /l %%i in (1,1,2) do echo:
echo|set/p=.                                                & for /l %%i in (1,1,3) do echo|set/p=^^^>
echo:
for /f "delims=" %%i in ("*") do echo:                                %green%?? My ip address.. Retrieveing........%reset%
for /f "delims=" %%i in ('%website% 2^>NUL') do set ext_ip=%%i
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| find "IPv4 Address"') do (
set /a index+=1
set ipv4[!index!]=%%i
)
call :printaddresses

:choose
choice /c !args!zrc /n /d z /t 3 >NUL
set errors=%errorlevel%
:chooseagainchooser
set /a whatpick=errors-1
echo:
if %whatpick% Lss %ext_number% CALL echo %%ipv4[%whatpick%]%% | clip & echo                                             ^>Copied I.P. #%whatpick%^^^!
if %whatpick% Lss 0 echo|set/p=.                                         wrong&goto choose
if %whatpick% == %ext_number% echo %ext_ip% | clip & echo                                             ^>Copied I.P. #%whatpick%^^^!
if %whatpick%==%z_number% goto choose
REM for /l %%i in (1,1,4) do echo:
if %whatpick%==%r_number% goto loop
if %whatpick%==%c_number% goto begin
echo:
echo:                                [P]ing website   [G]ateway ping  (0)Skip
choice /c pg0 /n >NUL
if %errorlevel%==1 call :pingdomain %pingdomains%
if %errorlevel%==2 call :pingdomain %gateways%
call :printaddresses
goto choose

:setcolor
set red=[101;93m
set green= [32m
set reset= [0m
exit /b

:pingdomain
for %%a in (%*) do ping -n 1 %%a |findstr /rc:"[=><][0-9]*ms" >NUL && echo %%a is UP || echo %%a isn't UP
pause >NUL
cls
exit /b
:construct_args
set args=
for /l %%i in (0,1,!index!) do set args=!args!%%i&echo: >NUL
set args=!args!%ext_number%
set /a z_number=ext_number+1
set /a r_number=ext_number+2
set /a c_number=ext_number+3
exit /b

:printaddresses
cls
for /f "tokens=2 delims= " %%i in ("%website%") do echo:      using  ^>%%i
for /l %%i in (1,1,10) do echo:
echo:                                            - == i.p. mate == -
for /l %%a in (0,1,!index!) do echo:                                    %%a^> My ip address: !ipv4[%%a]!
set /a ext_number=index+1
echo: 
echo                                     %ext_number%^> EXTERNAL I.P :  %red%%ext_ip%%reset%
echo:
call :construct_args
echo:                              [C]hange Client     [R]efresh      [!args!]Copy
exit /b



:::::::this section does not contain any code:::::::::::::::::::
author: u/Sudden-March-3952 ::::::::::::::::::::::::::::::::::::
                                           ::::::::::::::::::::::::::::::::::::::::

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
:((not recommendations))