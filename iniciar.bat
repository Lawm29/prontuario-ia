@echo off
title Prontuario IA - Servidor Local
cd /d "%~dp0"

echo.
echo ============================================
echo   PRONTUARIO IA - Servidor Local
echo ============================================
echo.

REM Tenta python (comando direto)
where python >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    python --version >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set "PY_CMD=python"
        goto :start_server
    )
)

REM Tenta o launcher py -3 (comum em Windows)
where py >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    py -3 --version >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        set "PY_CMD=py -3"
        goto :start_server
    )
)

echo [ERRO] Python nao foi encontrado no PATH.
echo.
echo Para instalar:
echo   1. Acesse https://www.python.org/downloads/
echo   2. Clique em "Download Python 3.x.x"
echo   3. Execute o instalador
echo   4. IMPORTANTE: marque "Add Python to PATH" na primeira tela
echo   5. Clique em "Install Now"
echo   6. Execute este iniciar.bat novamente
echo.
echo Apos instalar, voce pode verificar abrindo o Prompt de Comando
echo (Windows+R, digite "cmd", Enter) e rodando: python --version
echo.
pause
exit /b 1

:start_server
for /f "delims=" %%v in ('%PY_CMD% --version 2^>^&1') do set "PY_VER=%%v"
echo [OK] %PY_VER% encontrado.
echo [OK] Iniciando servidor em http://localhost:8000
echo.
echo O navegador vai abrir sozinho em alguns segundos.
echo.
echo IMPORTANTE: mantenha a janela preta "Servidor" aberta
echo enquanto usar o app. Para parar, basta fecha-la.
echo.

REM Inicia o servidor em uma NOVA janela para nao bloquear este script
start "Prontuario IA - Servidor (mantenha aberta)" cmd /k "%PY_CMD% -m http.server 8000"

REM Espera 2 segundos para o servidor inicializar
timeout /t 2 /nobreak >nul

REM Abre o navegador no app
start "" "http://localhost:8000"

echo.
echo App aberto em http://localhost:8000
echo.
echo - Para PARAR o servidor: feche a janela preta "Servidor"
echo - Para USAR o app: a aba do navegador que abriu ja esta pronta
echo - Esta janela pode ser fechada com seguranca (X no canto)
echo.
pause
