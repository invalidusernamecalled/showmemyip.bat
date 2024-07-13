@setlocal enabledelayedexpansion & echo off
set gateways=
set websites=
set pingdomains=
set website_index=1

if not exist key.domains.whatismyip.bat call :createkey
           call key.domains.whatismyip.bat


call :findgateways




if exist "%tmp%\whatismyip.config.client.conf" for /f "delims=" %%i in ('type "%tmp%\whatismyip.config.client.conf"') do set website_index=%%i&set add_options=/d c /t 1



for %%a in (%websites%) do set /a total_index+=1





:begin
cls
echo:Select Client:
echo:
set index_search=0
for %%a in (%websites%) do (
set /a index_search+=1
if !index_search! == %website_index% (echo:          ^>%%~a&set website=%%~a) else (echo:           %%~a)
)
echo|set/p=z^=down x^=up [C]go
choice /c zxc  /n %add_options% >NUL
set add_options=/d c /t 20
if %errorlevel%==3 goto next
if %errorlevel%==1 (set /a website_index+=1) else (set /a website_index-=1)
if %website_index% GTR %total_index% set /a website_index=%total_index%
if %website_index% LSS 1   set /a website_index=1
goto begin
:next
echo %website_index% >"%tmp%\whatismyip.config.client.conf"
call :setcolor
set first_time=0
:loop
if not defined ext_ip set ext_ip=   [refresh to load]
set /a index=-1
for /l %%i in (1,1,2) do echo:
echo|set/p=.                                                & for /l %%i in (1,1,3) do echo|set/p=^^^>
echo:
for /f "delims=" %%i in ("*") do echo:                                %green%?? My ip address.. Retrieveing........%reset%
if %first_time% NEQ 0 for /f "delims=" %%i in ('%website% 2^>NUL') do set ext_ip=%%i
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| find "IPv4 Address"') do (
set /a index+=1
set ipv4[!index!]=%%i
)
set total_index=%index%
call :construct_args
call :printaddresses

:choose
choice /c !args!zrc%q_number% /n  >NUL
set errors=%errorlevel%
:chooseagainchooser
set /a whatpick=errors-1
echo:
if %whatpick% LEQ %total_index% CALL echo %%ipv4[%whatpick%]%% | clip & echo                                             ^>Copied I.P. #%whatpick%^^^!
if %whatpick% Lss 0 echo|set/p=.                                         wrong&goto choose
if %first_time% NEQ 0 if %whatpick% == %ext_number% echo %ext_ip% | clip & echo                                             ^>Copied I.P. #%whatpick%^^^!
if %whatpick%==%z_number% goto choose
REM for /l %%i in (1,1,4) do echo:
if %whatpick%==%r_number% set first_time=1&goto loop
if %whatpick%==%c_number% goto begin
echo:                                [P]ing website   [g]ateway ping  {%q_number%}Skip
echo|set/p=$&choice /c pg%q_number% /n >NUL
if %errorlevel%==1 call :pingdomain %pingdomains%
if %errorlevel%==2 call :pingdomain %gateways%
call :printaddresses
goto choose

:findgateways
set found_gateway=0
set found_gateways=
for /f "tokens=2 delims=:" %%i in ('ipconfig ^| find /i "default gateway"') do (
call :checkgateways %%i 
if !found_gateway!==0 set gateways=%gateways% "%%i"
if !found_gateway!==0 set found_gateways=!found_gateways! "%%i"
)
exit /b
:checkgateways
set found_gateway=0
for %%a in (%gateways%) do (
if "%%~a"=="%~1" set /a found_gateway=1
)
exit /b

:setcolor
set red=[101;93m
set green= [32m
set reset= [0m
exit /b

:pingdomain
echo:
echo|set/p=^^^>^^^>^^^>...working
echo:
for %%a in (%*) do ping -n 1 %%~a |findstr /rc:"[=><][0-9]*ms" >NUL &&(echo|set/p=%%~a is UP&echo:) || (echo|set/p=%%~a isn't UP&echo:)
pause >NUL
cls
exit /b
:construct_args
set args=
for /l %%i in (0,1,!index!) do set args=!args!%%i&echo: >NUL
if %first_time% NEQ 0 set /a ext_number=index+1
set args=!args!%ext_number%
set /a z_number=ext_number+1
set /a r_number=ext_number+2
set /a c_number=ext_number+3
set /a q_number=ext_number+4
exit /b

:printaddresses
cls
for /f "tokens=2 delims= " %%i in ("%website%") do echo:      using  ^>%%i 
echo:
echo|set /p=.          auto-found gateways: & for %%a in (%found_gateways%) do echo|set/p=%%~a, 
echo:
for /l %%i in (1,1,8) do echo:

for /l %%a in (0,1,!index!) do echo:                                    %%a^> My ip address: !ipv4[%%a]!
echo: 
echo                                     %ext_number%^> EXTERNAL I.P :  %green%%ext_ip%%reset%
echo:
echo:                            [C]hange Client      [R]efresh        [!args!]Copy      {%q_number%}toolbox         
exit /b

:createkey
echo set websites="curl ifconfig.me" "curl api.ipify.org" "curl ipinfo.io/ip" "curl ipecho.net/plain" > key.domains.whatismyip.bat
echo set gateways="127.0.0.1" >> key.domains.whatismyip.bat
echo set pingdomains="google.com" "yahoo.com" "twitter.com" "youtube.com" >> key.domains.whatismyip.bat

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