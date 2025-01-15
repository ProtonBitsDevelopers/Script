@echo off


:menu
cls
echo ====================================================================================================
echo         Welcome user!
echo         Script for configuring the system in Windows 10 and 11;
echo         Versao 2.0 -Matheus Marcelo
echo ====================================================================================================
echo.
echo Choose your desired option:
echo 1. Parte 1 (IP Configuration)
echo 2. Parte 2 (First installation - Optimize the system)
echo 3. Parte 3 (Chocolatey installation)
echo 4. Parte 4 (Software and Driver Installations)
echo 5. Parte 5 (Definition of the Department)
echo 6. Parte 6 (Final - Close all services of installation)
echo 7. Parte 7 (Remove softwares of the system)
echo 0. Sair
echo.

set /p opcao="Digite o numero da opcao desejada: "

if "%opcao%"=="1" goto parte1
if "%opcao%"=="2" goto parte2
if "%opcao%"=="3" goto parte3
if "%opcao%"=="4" goto parte4
if "%opcao%"=="5" goto parte5
if "%opcao%"=="6" goto parte6
if "%opcao%"=="7" goto parte7
if "%opcao%"=="0" goto sair

echo Opcao invalida!
timeout /t 2 >nul
goto menu

:parte1
echo Executando a Parte 1...
@echo off

@echo ====================================================================================================
@echo         Este script vai alterar o endereco TCP/IP para: 192.168.0.163, gateway: 192.168.0.1
@echo         E DNS preferencial para 192.168.0.1, e reiniciar o serviço LANMAN
@echo ====================================================================================================
pause
REM alterar ip
netsh interface ipv4 set address name="Ethernet" static 192.168.0.163 255.255.255.0 192.168.0.1
netsh interface ipv4 set dns name="Ethernet" static 192.168.0.1
rem reiniciar serviço de rede LAN
net stop LanmanWorkstation
net start LanmanWorkstation
msg %username% Configuracoes de Rede Concluidas com Sucesso!
goto menu 


:parte2
echo Executando a Parte 2...
@echo off
REM Remover aplicativos de: Clima, Dicas, Noticias, OneNote, Telefone, Holographic, Print3D, 3DViewer, Skype, Spotify, Xbox, candycrush, MixedR, TEams, OneDrive, Cortana, Oneconected
rem powershell -Command "Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.Windows.HolographicFirstRun | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage SpotifyAB.SpotifyMusic | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage king.com.CandyCrushSaga | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.549981C3F5F10 | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage Microsoft.OneDrive | Remove-AppxPackage"
rem powershell -Command "Get-AppxPackage MicrosoftTeams | Remove-AppxPackage"
 

REM Copiar a pasta de assets para o disco Local
set "source=%USERPROFILE%\Desktop\assets"
set "destination=C:\"

if not exist "%source%" (
    echo A pasta de origem não existe.
    pause
    exit /b
)

if not exist "%destination%" (
    echo O diretório de destino não existe.
    pause
    exit /b
)

xcopy "%source%" "%destination%" /E /I /Y

if %errorlevel% equ 0 (
    echo Pasta copiada com sucesso para %destination%
) else (
    echo Houve um erro ao copiar a pasta.
)

REM Desabilitar envio de dados para melhorias (Microsoft)
REM exceto serviços SMB, FTP, RemoteControl....
sc config DiagTrack start= disabled
sc config diagnosticshub.standardcollector.service start= disabled
sc config dmwappushservice start= disabled
sc config iphlpsvc start= disabled
sc config DoSvc start= disabled
sc config DPS start= disabled

REM Desabilitar serviço de VPN como SSTP, IPsec e RasMan
sc config SstpSvc start= disabled
sc config IKEEXT start= disabled

REM Desabilitar atualizações de aplicativos da Microsoft Store
sc config WMPNetworkSvc start= disabled
sc config wisvc start= disabled
sc config RasMan start= disabled

REM Desabilitar outros serviços que podem influenciar no desempenho do S.O
sc config VSS start= disabled 
sc config RemoteAccess start= disabled
sc config SharedRealitySvc start= disabled
sc config PhoneSvc start= disabled
sc config perceptionsimulation start= disabled
echo Serviços não essenciais desabilitados com sucesso!


REM Desabilitar tarefas agendadas do Windows (coleta de dados)
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "Microsoft\Office\Office Automatic Updates 2.0" /Disable
schtasks /Change /TN "Microsoft\Office\Office Feature Updates" /Disable
schtasks /Change /TN "Microsoft\Office\Office Feature Updates Logon" /Disable
schtasks /Change /TN "MicrosoftEdgeUpdateTaskMachineCore" /Disable
schtasks /Change /TN "MicrosoftEdgeUpdateTaskMachineUA" /Disable
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /Disable
schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /Disable
schtasks /Change /TN "Microsoft\Windows\NetTrace\GatherNetworkInfo" /Disable
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /Disable
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /Disable
echo Tarefas agendadas não essenciais, desabilitados com sucesso!

REM ALTO IMPACTO NA FUNCIONALIDADE DO SISTEMA (DESEMPENHO):
REM *** Desabilitar Aplicativos em Segundo Plano ***
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /V "LetAppsRunInBackground_UserInControlOfTheseApps" /F
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /V "LetAppsRunInBackground_ForceAllowTheseApps" /F
reg delete "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /V "LetAppsRunInBackground_ForceDenyTheseApps" /F
REM ***Aumentar velocidade dos menus***
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /t REG_SZ /d 5 /f
REM BAIXO IMPACTO DE DESEMPENHO NO SISTEMA (Intuito de simplesmente desativar o que o usuário não precisa):
REM *** Remover botão busca da barra de tarefas ***
REG ADD "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /d 0 /t REG_DWORD /f
REM *** Desabilitar Localização ***
reg add /f "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d Deny /f
REM *** Desabilitar Mobile Hotspot ***
REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Network Connections" /v NC_ShowSharedAccessUI /d 0 /t REG_DWORD /f
REM *** Desabilitar dicionário pessoal ***
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\CPSS\Store\InkingAndTypingPersonalization" /v Value /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f
REM ***Desabilitar envio de escrita a Microsoft*
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /V "AllowLinguisticDataCollection" /T REG_DWORD /D 0 /F
REM ***Desabilitar Experiencias Personalizadas***
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableTailoredExperiencesWithDiagnosticData" /t REG_DWORD /d 1 /f
REM ***Desabilitar reconhecimento de voz online***
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\InputPersonalization" /v "AllowInputPersonalization" /t REG_DWORD /d 0 /f
REM Ativação por voz desativada acima da tela de bloqueio:
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v NoLockScreenVoiceActivation /t REG_DWORD /d 1 /f
REM Desativa sugestão de conteúdo:
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f


REM CONFIGURAÇÕES UNIVERSAIS - WINDOWS 10 E 11{}


REM CONFIGURAÇÕES DE ENERGIA
REM Definir proteção de tela com Texto 3D:
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 1 /f
reg add "HKCU\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d 0 /f
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600 /f
reg add "HKCU\Control Panel\Desktop" /v SCRNSAVE.EXE /t REG_SZ /d "%SystemRoot%\System32\ssText3d.scr" /f
REM Tempo de bloqueio da tela de 10 minutos:
reg add "HKCU\Control Panel\Desktop" /v ScreenSaveTimeOut /t REG_SZ /d 600 /f
REM Define o plano de energia ativo como "Equilibrado"
powercfg /setactive 381b4222-f694-41f0-9685-ff5bb260df2e
REM Define as opções de energia para desligar o vídeo e suspender atividade como "Nunca"
powercfg /change monitor-timeout-ac 0
powercfg /change monitor-timeout-dc 0
powercfg /change standby-timeout-ac 0
powercfg /change standby-timeout-dc 0
REM Atualiza as configurações de energia
powercfg /S 381b4222-f694-41f0-9685-ff5bb260df2e
echo As opções de energia foram configuradas com sucesso!

REM Remover as configurações de ações rápidas do painel de controle do usuário atual, aguardar 5s e reinicia o explorer
TIMEOUT /T 5
taskkill /f /im explorer.exe
start explorer.exe
msg %username% Configuracoes Basicas Concluidas com Sucesso!

goto menu



:parte3 
echo Executando a Parte 3...
 
REM ***Instalar o Chocolatey***
REM Verificar se o Chocolatey já está instalado
choco -v >nul 2>&1
if %errorlevel% neq 0 (
    REM Instala o Chocolatey
    powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"
)
msg %username% Chocolatey Instalado com Sucesso.
goto menu

:parte4
echo Executando a Parte 4...
@echo off
rem Coloque o código da Parte 2 aqui
REM INSTALACAO DOS SOFTWARES
REM ***Instalar Frameworks***
rem choco install dotnetcore-desktop-runtime --yes
rem choco install dotnet5 --yes
rem choco install dotnet6 --yes
REM ***Instalar Drivers***
rem choco install intel-chipset-device-software --yes
rem choco install intel-graphics-driver --yes
rem choco install intel-rst-driver --yes
rem choco install nvidia-display-driver --yes
rem choco install realtek-audio-driver --yes
rem choco install amd-ryzen-master --yes
REM ***Instalar Navegadores e Programas para Internet***
choco install googlechrome --yes
choco install firefox --yes
choco install adobereader --yes
choco install winrar --yes
choco install jre8 --yes
echo Google Chrome, Firefox, Adobe, Winrar e Java instalados com sucesso!
REM ***Desinstalar o Chocolatey***
choco uninstall chocolatey --yes
echo Chocolatey desinstalado com sucesso!
REM ***Definir Chrome como navegador web padrão***
REG ADD HKCU\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice /v ProgId /d ChromeHTML /f
REG ADD HKCU\SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\https\UserChoice /v ProgId /d ChromeHTML /f
REM ***Definir Adobe Reader como leitor de PDF padrão***
REG ADD HKCU\SOFTWARE\Microsoft\Windows\Shell\Associations\MIMEAssociations\application/pdf\UserChoice /v ProgId /d AcroExch.Document.DC /f


REM *** Instalar .NET Framework 3.5 ***
Dism /online /norestart /Enable-Feature /FeatureName:"NetFx3"


msg %username% Softwares Instalados com Sucesso!
goto menu


:parte5
echo Executando a Parte 5...
REM DEFINIR PAPEL DE PAREDE DE ACORDO COM O DEPARTAMENTO:

REM CONFIGURAÇÕES DE NOME DE USUARIO
set /p newComputerName=Digite o novo nome do computador e do disco C: 
REM Remover as aspas do nome
set newComputerName=%newComputerName:"=%
REM Renomear o computador
wmic computersystem where name="%computername%" call rename name="%newComputerName%"
REM Renomear o rótulo do disco C:
label C: %newComputerName%
echo Nomes alterados com sucesso!

setlocal
set "imageFolder=C:/assets"
set "imageFile="
echo Qual imagem você deseja definir?
echo 1 - Assistencia Social
echo 2 - Educacao
echo 3 - Saude
echo 4 - Geral
echo 5 - CRAS
set /p choice=
if "%choice%"=="1" (
    set "imageFile=assist_s.jpg"  
        
    REM ICONE DO SRV SMB	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo URL=file://192.168.0.247/tes_dpas >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconFile=C:\assets\icon_Pref.ico >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"

    REM ICONE DO SISTEMA DE CHAMADOS	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo URL=http://192.168.0.98:3000 >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconFile=C:\assets\chamadoTI.ico >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Chamados_TI.url
  
) else if "%choice%"=="2" (
    set "imageFile=educacao.jpg"
    
        
    REM ICONE DO SRV SMB	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo URL=file://192.168.0.247/tes_deduc >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconFile=C:\assets\icon_Pref.ico >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"

    REM ICONE DO SISTEMA DE CHAMADOS	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo URL=http://192.168.0.98:3000 >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconFile=C:\assets\chamadoTI.ico >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Chamados_TI.url


) else if "%choice%"=="3" (
    set "imageFile=saude.png"
    
    REM ICONE DO SRV SMB	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo URL=file://192.168.0.247/tes_desau >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconFile=C:\assets\icon_Pref.ico >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"

    REM ICONE DO PEC
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\PEC.url"
    echo URL=http://192.168.0.242:8080/ >> "%USERPROFILE%\Desktop\PEC.url"
    echo IconFile=%imageFolder%\icon_PEC.ico >> "%USERPROFILE%\Desktop\PEC.url
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\PEC.url"
    
    REM ICONE DO SISTEMA DE CHAMADOS	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo URL=http://192.168.0.98:3000 >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconFile=C:\assets\chamadoTI.ico >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Chamados_TI.url
    
) else if "%choice%"=="4" (
    set "imageFile=geral.jpg"
        
    REM ICONE DO SRV SMB	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo URL=file://192.168.0.247/ >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconFile=C:\assets\icon_Pref.ico >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    
    REM ICONE DO SISTEMA DE CHAMADOS	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo URL=http://192.168.0.98:3000 >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconFile=C:\assets\chamadoTI.ico >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Chamados_TI.url

) else if "%choice%"=="5" (
    set "imageFile=cras.jpg"
        
    REM ICONE DO SRV SMB	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo URL=file://192.168.0.247/ >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconFile=C:\assets\icon_Pref.ico >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Prefeitura_Cloud.url"
    
    REM ICONE DO SISTEMA DE CHAMADOS	
    echo [InternetShortcut] > "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo URL=http://192.168.0.98:3000 >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconFile=C:\assets\chamadoTI.ico >> "%USERPROFILE%\Desktop\Chamados_TI.url"
    echo IconIndex=0 >> "%USERPROFILE%\Desktop\Chamados_TI.url

) else (
    echo Opção inválida.
    exit /b
)
rem Define a imagem como papel de parede usando o Windows Script Host (WSH)
echo Set oShell = CreateObject^("WScript.Shell"^) > SetWallpaper.vbs
echo oShell.RegWrite "HKCU\Control Panel\Desktop\Wallpaper", "%imageFolder%\%imageFile%" >> SetWallpaper.vbs
echo oShell.Run "RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters", 1, True >> SetWallpaper.vbs
cscript //NoLogo SetWallpaper.vbs
del SetWallpaper.vbs
endlocal
echo Papel de parede será definido em breve...


msg %username% Departamento Definido com Sucesso.
goto menu




:parte6
echo Executando a Parte 6...
@ECHO OFF

@echo ============================================================================
@echo    Script de limpeza de arquivos temporarios em todos usuarios do Windows.
@echo    E função de desabilitar o WindowsUpdate e AdobeReader
@echo ============================================================================
pause

REM desativa os serviços do adobe Reader e do WIndows Update
net stop wuauserv
sc config wuauserv start= disabled
net stop AdobeARMservice
sc config AdobeARMservice start= disabled

cls
%homedrive%
cd %USERPROFILE%
cd..
set profiles=%cd%

for /f "tokens=* delims= " %%u in ('dir /b/ad') do (

cls
title Deletando %%u COOKIES. . .
if exist "%profiles%\%%u\cookies" echo Deletando....
if exist "%profiles%\%%u\cookies" cd "%profiles%\%%u\cookies"
if exist "%profiles%\%%u\cookies" del *.* /F /S /Q /A: R /A: H /A: A

cls
title Deletando %%u Temp Files. . .
if exist "%profiles%\%%u\Local Settings\Temp" echo Deletando....
if exist "%profiles%\%%u\Local Settings\Temp" cd "%profiles%\%%u\Local Settings\Temp"
if exist "%profiles%\%%u\Local Settings\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\Local Settings\Temp" rmdir /s /q "%profiles%\%%u\Local Settings\Temp"

cls
title Deletando %%u Temp Files. . .
if exist "%profiles%\%%u\AppData\Local\Temp" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Temp" cd "%profiles%\%%u\AppData\Local\Temp"
if exist "%profiles%\%%u\AppData\Local\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Temp" rmdir /s /q "%profiles%\%%u\AppData\Local\Temp"

cls
title Deletando %%u Temporary Internet Files. . .
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" echo Deletando....
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" cd "%profiles%\%%u\Local Settings\Temporary Internet Files"
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\Local Settings\Temporary Internet Files" rmdir /s /q "%profiles%\%%u\Local Settings\Temporary Internet Files"

cls
title Deletando %%u Temporary Internet Files. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\Temporary Internet Files"

cls
title Deletando %%u WER Files. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\WER\ReportArchive"


cls
title Deletando %Systemroot%\Temp
if exist "%Systemroot%\Temp" echo Deletando....
if exist "%Systemroot%\Temp" cd "%Systemroot%\Temp"
if exist "%Systemroot%\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%Systemroot%\Temp" rmdir /s /q "%Systemroot%\Temp"

cls
title Deletando %SYSTEMDRIVE%\Temp
if exist "%SYSTEMDRIVE%\Temp" echo Deletando....
if exist "%SYSTEMDRIVE%\Temp" cd "%SYSTEMDRIVE%\Temp"
if exist "%SYSTEMDRIVE%\Temp" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%SYSTEMDRIVE%\Temp" rmdir /s /q "%Systemroot%\Temp"

cls
title Deletando %%u FIREFOX TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" cd "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles"
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles" rmdir /s /q "%profiles%\%%u\AppData\Local\Mozilla\Firefox\Profiles"

cls
title Deletando %%u CHROME TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" cd "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache"
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Google\Chrome\User Data\Default\Cache"

cls
title Deletando %%u EDGE TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCache"

cls
title Deletando %%u EDGE COOKIES. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" cd "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Windows\INetCookies"

cls
title Deletando %%u RDP TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" cd "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache"
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Microsoft\Terminal Server Client\Cache"

cls
title Deletando %%u OPERA TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" cd "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache"
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Caches" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Opera Software\Opera Next\Cache"


cls
title Deletando %%u VIVALDI TEMP. . .
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" echo Deletando....
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" cd "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache"
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" del *.* /F /S /Q /A: R /A: H /A: A
if exist "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache" rmdir /s /q "%profiles%\%%u\AppData\Local\Vivaldi\User Data\Default\Cache"

)

cls
goto END




:parte7
echo Executando a Parte 7...
@ECHO OFF

@echo ============================================================================
@echo    Script de remoção softwares de fábrica.
@echo ============================================================================
pause

:: Habilitar a execução de scripts PowerShell
powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope Process"

:: Remover o pacote específico
powershell -Command "Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage"
powershell -Command "Get-AppxPackage -allusers *Microsoft.549981C3F5F10* | Remove-AppxPackage"

:: Definir a lista de aplicativos a serem desinstalados
set appsToUninstall=(
    "Microsoft.3DBuilder",
    "Microsoft.BingWeather",
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Messaging",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.Office.OneNote",
    "Microsoft.MixedReality.Portal",
    "Microsoft.OneConnect",
    "Microsoft.People",
    "Microsoft.Print3D",
    "Microsoft.SkypeApp",
    "Microsoft.StorePurchaseApp",
    "microsoft.windowscommunicationsapps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsMaps",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone"
)

:: Iterar sobre a lista e desinstalar os aplicativos
for %%a in %appsToUninstall% do (
    powershell -Command "Get-AppxPackage -Name %%a -AllUsers | Remove-AppxPackage"
    powershell -Command "Get-AppxProvisionedPackage -Online | Where-Object DisplayName -eq '%%a' | Remove-AppxProvisionedPackage -Online"
)

msg %username% Softwares desinstalados com sucesso!
goto menu


:END
exit
pause
goto menu

:sair
echo Exiting the program...
exit
