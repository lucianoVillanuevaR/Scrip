@echo off
title Herramienta para GTA V Online by LENONART

:: SIMPLE LOGGING
set "LOGFILE=%TEMP%\menu_gta_log.txt"
echo [%date% %time%] Iniciando %~nx0 >> "%LOGFILE%"

:: Pide permisos de administrador si no se tienen
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo.
    echo.
    echo [+] Solicitando permisos de administrador...
    :: Re-lanzar con elevacion y pasar argumentos
    POWERSHELL -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath '%~dpnx0' -ArgumentList '%*' -Verb RunAs"
    echo [%date% %time%] Intento de elevacion iniciado >> "%LOGFILE%"
    EXIT /B
)

:MENU
cls
echo.
echo ==================================================
echo       HERRAMIENTA PARA GTA V ONLINE (2025)
echo       VER 3.0
echo       by Luciano Villanueva
echo ==================================================
echo.
echo --- TRUCO DE RED ---
echo 1. ON (Activar truco)
echo 2. OFF (Desactivar truco)
echo.
echo --- CLUB DE COCHES DE LS ---
echo 3. Version Enhanced (GTA5_Enhanced.exe)
echo 4. Version Legacy (GTA5.exe)
echo.
echo 5. Salir
echo ==================================================
set /p choice=Elige una opcion: 

:: Aceptar entrada indiferente a mayusculas/minusculas
if /I "%choice%"=="1" goto BLOCK_IP
if /I "%choice%"=="2" goto UNBLOCK_IP
if /I "%choice%"=="3" goto SUSPEND_ENHANCED
if /I "%choice%"=="4" goto SUSPEND_LEGACY
if /I "%choice%"=="5" goto END
echo Opcion invalida. Intentalo de nuevo.
pause
goto MENU

:BLOCK_IP
cls
echo.
echo ===========================================
echo  [+] ACTIVANDO TRUCO DE RED...
echo ===========================================
:: Confirmacion
choice /m "Confirmar: anadir regla de firewall que bloquea 192.81.241.171?"
if errorlevel 2 (
    echo Cancelado por el usuario.
    echo [%date% %time%] Bloqueo cancelado por usuario >> "%LOGFILE%"
    pause
    goto MENU
)

:: Eliminar regla previa si existe para evitar duplicados
netsh advfirewall firewall delete rule name="TRUCO_GTA" >nul 2>&1

netsh advfirewall firewall add rule name="TRUCO_GTA" dir=out action=block remoteip=192.81.241.171 profile=any enable=yes >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [ERROR] No se pudo anadir la regla del firewall.
    echo [%date% %time%] ERROR al anadir regla de firewall >> "%LOGFILE%"
) ELSE (
    echo [OK] Truco activado correctamente.
    echo [%date% %time%] Regla TRUCO_GTA anadida >> "%LOGFILE%"
)
echo.
pause
goto MENU

:UNBLOCK_IP
cls
echo.
echo ===========================================
echo  [-] DESACTIVANDO TRUCO DE RED...
echo ===========================================
choice /m "Confirmar: eliminar la regla TRUCO_GTA?"
if errorlevel 2 (
    echo Cancelado por el usuario.
    echo [%date% %time%] Eliminacion cancelada por usuario >> "%LOGFILE%"
    pause
    goto MENU
)

netsh advfirewall firewall delete rule name="TRUCO_GTA" >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo [AVISO] La regla no existia o no se pudo eliminar.
    echo [%date% %time%] Aviso: no se pudo eliminar TRUCO_GTA (quizas no existia) >> "%LOGFILE%"
) ELSE (
    echo [OK] Truco desactivado correctamente.
    echo [%date% %time%] Regla TRUCO_GTA eliminada >> "%LOGFILE%"
)
echo.
pause
goto MENU

:SUSPEND_ENHANCED
cls
echo.
echo ===========================================
echo  [+] AUTOMATIZANDO PARA ENHANCED VERSION...
echo ===========================================
echo.
echo [1/3] Buscando el proceso GTA5_Enhanced.exe...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $proc = Get-Process -Name GTA5_Enhanced -ErrorAction Stop; Write-Host '[OK] Proceso encontrado. Suspendiendo...'; $Error.Clear(); Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class Win32 { [DllImport(\"ntdll.dll\")] public static extern int NtSuspendProcess(IntPtr hProcess); [DllImport(\"ntdll.dll\")] public static extern int NtResumeProcess(IntPtr hProcess); }'; [Win32]::NtSuspendProcess($proc.Handle) | Out-Null; Write-Host '   > Proceso suspendido.'; Write-Host '[2/3] Esperando 12 segundos...'; Start-Sleep -Seconds 12; Write-Host '[3/3] Reanudando el proceso...'; [Win32]::NtResumeProcess($proc.Handle) | Out-Null; Write-Host '   > Proceso reanudado.'; Write-Host '[OK] Proceso completado.'; exit 0 } catch { Write-Host '[ERROR] No se pudo suspender/reanudar el proceso.'; exit 1 }"
echo.
pause
goto MENU

:SUSPEND_LEGACY
cls
echo.
echo ===========================================
echo  [+] AUTOMATIZANDO PARA LEGACY VERSION...
echo ===========================================
echo.
echo [1/3] Buscando el proceso GTA5.exe...
powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $proc = Get-Process -Name GTA5 -ErrorAction Stop; Write-Host '[OK] Proceso encontrado. Suspendiendo...'; $Error.Clear(); Add-Type -TypeDefinition 'using System; using System.Runtime.InteropServices; public static class Win32 { [DllImport(\"ntdll.dll\")] public static extern int NtSuspendProcess(IntPtr hProcess); [DllImport(\"ntdll.dll\")] public static extern int NtResumeProcess(IntPtr hProcess); }'; [Win32]::NtSuspendProcess($proc.Handle) | Out-Null; Write-Host '   > Proceso suspendido.'; Write-Host '[2/3] Esperando 12 segundos...'; Start-Sleep -Seconds 12; Write-Host '[3/3] Reanudando el proceso...'; [Win32]::NtResumeProcess($proc.Handle) | Out-Null; Write-Host '   > Proceso reanudado.'; Write-Host '[OK] Proceso completado.'; exit 0 } catch { Write-Host '[ERROR] No se pudo suspender/reanudar el proceso.'; exit 1 }"
echo.
pause
goto MENU

:END
echo.
echo [+] Limpiando y saliendo...
rem Intenta eliminar la regla del firewall antes de salir para no dejarla activa.
netsh advfirewall firewall delete rule name="TRUCO_GTA" >nul 2>&1
echo [%date% %time%] Saliendo y limpieza final >> "%LOGFILE%"
timeout /t 2 /nobreak >nul
exit