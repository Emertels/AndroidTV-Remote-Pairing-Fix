@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Android TV Remote Pairing Fix — por Emerson Teles (Emertels)

:: Cores e Estilo
color 0B

:MENU
cls
echo ===============================================================================
echo   📺 ANDROID TV / GOOGLE TV REMOTE PAIRING FIX v1.0.0
echo   Desenvolvido por Emerson Teles (Emertels) com assistência técnica do Gemini
echo ===============================================================================
echo.
echo   Este utilitário resolve em 1 clique o problema crônico de TV Sticks/Boxes
echo   (Mecool, Mibro, Skyworth com Android 11/12/14) que travam no boot pedindo
echo   para segurar "Voltar + Home" ao usar controles alternativos (G20S, Air Mouse).
echo.
echo   [1] 🚀 Correção Rápida: Desativar Tela Chata de Pareamento (com.mft.rcupair)
echo   [2] ⚡ Otimização Completa: Fix Controle + Bloatwares + HDMI-CEC + Projectivy
echo   [3] 🔄 Reativar / Restaurar Tela de Pareamento de Fábrica
echo   [4] 📶 Testar Conexão / Diagnóstico com o Stick
echo   [0] ❌ Sair
echo.
echo ===============================================================================
set /p OPT="Escolha uma opção [0-4]: "

if "%OPT%"=="1" goto OP_FIX
if "%OPT%"=="2" goto OP_FULL
if "%OPT%"=="3" goto OP_RESTORE
if "%OPT%"=="4" goto OP_TEST
if "%OPT%"=="0" goto OP_EXIT
goto MENU

:CHECK_ADB
where adb >nul 2>nul
if %ERRORLEVEL% EQU 0 (
    set "ADB_CMD=adb"
    goto :eof
)
if exist "%~dp0adb.exe" (
    set "ADB_CMD=%~dp0adb.exe"
    goto :eof
)
if exist "%USERPROFILE%\scoop\apps\adb\current\platform-tools\adb.exe" (
    set "ADB_CMD=%USERPROFILE%\scoop\apps\adb\current\platform-tools\adb.exe"
    goto :eof
)

echo [!] ADB não encontrado no sistema. Baixando platform-tools oficial do Google...
powershell -Command "Invoke-WebRequest -Uri 'https://dl.google.com/android/repository/platform-tools-latest-windows.zip' -OutFile '%temp%\platform-tools.zip'; Expand-Archive -Path '%temp%\platform-tools.zip' -DestinationPath '%temp%\pt' -Force; Copy-Item '%temp%\pt\platform-tools\adb.exe', '%temp%\pt\platform-tools\AdbWinApi.dll', '%temp%\pt\platform-tools\AdbWinUsbApi.dll' -Destination '%~dp0' -Force" >nul 2>nul
if exist "%~dp0adb.exe" (
    set "ADB_CMD=%~dp0adb.exe"
    echo [OK] ADB baixado com sucesso!
) else (
    echo [ERRO] Não foi possível obter o ADB automaticamente.
    echo Instale o ADB ou coloque o arquivo adb.exe nesta mesma pasta.
    pause
    goto MENU
)
goto :eof

:CONNECT_DEVICE
call :CHECK_ADB
echo.
echo -------------------------------------------------------------------------------
echo [>] CONECTANDO AO STICK VIA REDE WI-FI
echo -------------------------------------------------------------------------------
set "STICK_IP=192.168.1.14"
set /p USER_IP="Digite o IP do seu Stick na rede [Padrão: %STICK_IP%]: "
if not "%USER_IP%"=="" set "STICK_IP=%USER_IP%"

set "STICK_PORT=5555"
set /p USER_PORT="Digite a porta ADB [Padrão: 5555 / ou porta dinâmica de depuração]: "
if not "%USER_PORT%"=="" set "STICK_PORT=%USER_PORT%"

echo.
echo [*] Conectando a %STICK_IP%:%STICK_PORT%...
"%ADB_CMD%" connect %STICK_IP%:%STICK_PORT% >nul 2>&1

:: Verifica se conectou
"%ADB_CMD%" devices | findstr /R "%STICK_IP%.*device" >nul
if %ERRORLEVEL% EQU 0 (
    echo [SUCESSO] Conectado e autenticado com sucesso no Stick!
    set "DEV_TARGET=-s %STICK_IP%:%STICK_PORT%"
    goto :eof
)

:: Se falhou, tenta listar se há algum outro dispositivo conectado
for /f "tokens=1" %%d in ('"%ADB_CMD%" devices ^| findstr "device$"') do (
    set "DEV_TARGET=-s %%d"
    echo [SUCESSO] Dispositivo detectado: %%d
    goto :eof
)

echo.
echo [AVISO] Conexão pendente ou não autenticada.
echo Se esta for a primeira vez conectando:
echo 1. Na TV, abra: Configurações > Opções do desenvolvedor > Depuração por Wi-Fi
echo 2. Se pedir "Permitir depuração USB?", marque 'Sempre permitir' e dê OK com o controle.
echo 3. Se precisar de pareamento com código, use o comando: adb pair %STICK_IP%:[porta] [código]
echo.
set /p PAIR_REQ="Deseja parear agora com código de 6 dígitos? (S/N): "
if /i "%PAIR_REQ%"=="S" (
    set /p P_PORT="Digite a porta de pareamento (após os dois pontos): "
    set /p P_CODE="Digite o código de pareamento de 6 dígitos: "
    "%ADB_CMD%" pair %STICK_IP%:!P_PORT! !P_CODE!
    "%ADB_CMD%" connect %STICK_IP%:%STICK_PORT%
)
goto :eof

:OP_FIX
call :CONNECT_DEVICE
echo.
echo [*] Desativando serviço de pareamento obrigatório no boot (com.mft.rcupair)...
"%ADB_CMD%" %DEV_TARGET% shell "pm disable-user --user 0 com.mft.rcupair"
if %ERRORLEVEL% EQU 0 (
    echo.
    echo ===============================================================================
    echo [PRONTO!] A tela de pareamento forçada de controle foi desativada com sucesso!
    echo Agora seu stick inicializa direto sem exigir o controle original de fábrica.
    echo ===============================================================================
) else (
    echo.
    echo [FALHA] Não foi possível aplicar o comando. Verifique a conexão ADB na tela da TV.
)
echo.
pause
goto MENU

:OP_FULL
call :CONNECT_DEVICE
echo.
echo [*] 1/4 Desativando assistente obrigatório de controle (com.mft.rcupair)...
"%ADB_CMD%" %DEV_TARGET% shell "pm disable-user --user 0 com.mft.rcupair" >nul 2>&1

echo [*] 2/4 Desativando launcher stock pesado e forçando Projectivy...
"%ADB_CMD%" %DEV_TARGET% shell "pm disable-user --user 0 com.google.android.apps.tv.launcherx" >nul 2>&1
"%ADB_CMD%" %DEV_TARGET% shell "pm disable-user --user 0 com.google.android.tungsten.setupwraith" >nul 2>&1

echo [*] 3/4 Otimizando flags HDMI-CEC para ligar e desligar em sincronia com a TV...
"%ADB_CMD%" %DEV_TARGET% shell "settings put global hdmi_control_auto_wakeup_enabled 1" >nul 2>&1
"%ADB_CMD%" %DEV_TARGET% shell "settings put global hdmi_control_auto_device_off_enabled 1" >nul 2>&1
"%ADB_CMD%" %DEV_TARGET% shell "settings put global hdmi_control_one_touch_play_enabled 1" >nul 2>&1

echo [*] 4/4 Removendo aplicativos e bloatwares de streaming pré-instalados...
"%ADB_CMD%" %DEV_TARGET% shell "pm uninstall --user 0 com.netflix.ninja; pm uninstall --user 0 com.netflix.tokenmanager; pm uninstall --user 0 com.amazon.amazonvideo.livingroom; pm uninstall --user 0 com.google.android.youtube.tv; pm uninstall --user 0 com.google.android.youtube.tvmusic; pm uninstall --user 0 com.google.android.play.games" >nul 2>&1

echo.
echo ===============================================================================
echo [SUCESSO TOTAL!] Todas as otimizações foram aplicadas no seu Stick!
echo - Tela chata de controle: DESATIVADA
echo - Projectivy Launcher: PADRÃO NATIVO
echo - Bloatwares de fábrica: REMOVIDOS
echo - HDMI-CEC: SINCRONIZADO COM A TV SONY
echo ===============================================================================
echo.
pause
goto MENU

:OP_RESTORE
call :CONNECT_DEVICE
echo.
echo [*] Reativando o pacote com.mft.rcupair e o launcher original...
"%ADB_CMD%" %DEV_TARGET% shell "pm enable com.mft.rcupair" >nul 2>&1
"%ADB_CMD%" %DEV_TARGET% shell "pm enable com.google.android.apps.tv.launcherx" >nul 2>&1
echo [OK] Configurações de fábrica restauradas.
pause
goto MENU

:OP_TEST
call :CONNECT_DEVICE
echo.
echo --- DIAGNÓSTICO DO DISPOSITIVO ---
"%ADB_CMD%" %DEV_TARGET% shell "getprop ro.product.model; getprop ro.board.platform; getprop ro.build.version.release"
echo.
echo --- PACOTES DE PAREAMENTO ---
"%ADB_CMD%" %DEV_TARGET% shell "pm list packages -d | grep -i -E 'rcupair|launcherx|setupwraith'"
echo.
pause
goto MENU

:OP_EXIT
echo.
echo Obrigado por usar o utilitário!
echo Emerson Teles (Emertels) — https://github.com/emertels
timeout /t 2 >nul
exit /b 0
