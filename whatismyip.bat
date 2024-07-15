@setlocal enabledelayedexpansion & echo off
set gateways=
set websites=
set pingdomains=
set website_index=1

if not exist keys.whatismyip.XZ12HW.txt call :createkey
           call :importkeys


call :findgateways


for %%a in (%websites%) do set /a total_index_websites+=1

if exist "%tmp%\whatismyip.config.client.conf" for /f "delims=" %%i in ('type "%tmp%\whatismyip.config.client.conf"') do set website_index=%%i&set add_options=/d 0 /t 20
set index_search=0
for %%a in (%websites%) do (
set /a index_search+=1
if !index_search! == %website_index% (set website=%%~a)
)
if not exist "%tmp%\whatismyip.config.client.conf" goto begin
goto next
:begin
cls
echo:Select Client:
echo:
set index_search=0
for %%a in (%websites%) do (
set /a index_search+=1
if !index_search! == %website_index% (echo:          ^>%%~a&set website=%%~a) else (echo:           %%~a)
)
echo:
echo:z=down x=up 
if not defined q_number echo|set/p={0}Next
if defined q_number echo|set/p={%q_number%}Next
choice /c zx0123456789d  /n %add_options% >NUL
if %errorlevel% GEQ 3 goto next
if %errorlevel%==1 (set /a website_index+=1) else (set /a website_index-=1)
if %website_index% GTR %total_index_websites% set /a website_index=%total_index_websites%
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
choice /c !args!zprg%q_number% /n  >NUL
set errors=%errorlevel%
:chooseagainchooser
set /a whatpick=errors-1
if %whatpick% LEQ %total_index% CALL echo %%ipv4[%whatpick%]%% | clip & echo                             ^>Copied I.P. #%whatpick%^^^!
if %whatpick% Lss 0 echo|set/p=.                                         wrong&goto choose
if %first_time% NEQ 0 if %whatpick% == %ext_number% echo %ext_ip% | clip & echo                             ^>Copied I.P. #%whatpick%^^^!
if %first_time%==0 if %whatpick% == %ext_number% echo                             ^>Not set
if %whatpick%==%z_number% goto choose
echo:
if %whatpick%==%r_number% set first_time=1&goto loop
if %whatpick%==%p_number% call :pingdomain %pingdomains%
if %whatpick%==%g_number% call :pingdomain %gateways%

echo:                            {%q_number%}Next  [C]Change client  
echo|set/p=$&choice /c cabdefghijklmnopqrstuvwxyz0123456789 /n >NUL
if %errorlevel%==1 goto begin
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
exit /b
:construct_args
set args=
for /l %%i in (0,1,!index!) do set args=!args!%%i&echo: >NUL
set /a ext_number=index+1
set args=!args!!ext_number!
set /a z_number=ext_number+1
set /a p_number=ext_number+2
set /a r_number=ext_number+3
set /a g_number=ext_number+4
set /a q_number=ext_number+5
if %q_number% GTR 9 set q_number=D
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
echo:                            [R]efresh     [p]ing website      [g]ateway ping      [!args!]Copy      {%q_number%}next
exit /b

:createkey
echo #websites# "curl ifconfig.me" "curl api.ipify.org" "curl ipinfo.io/ip" "curl ipecho.net/plain" > keys.whatismyip.XZ12HW.txt
echo #gateways# "127.0.0.1" >> keys.whatismyip.XZ12HW.txt
echo #pingdomains# "google.com" "yahoo.com" "twitter.com" "youtube.com" >> keys.whatismyip.XZ12HW.txt
:importkeys
for /f "tokens=1,2* delims=#" %%i in (keys.whatismyip.XZ12HW.txt) do set %%i=%%j
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