@echo off
chcp 65001

if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0

bcdedit >nul

if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)

:UACPrompt
%1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B

:UACAdmin
cd /d "%~dp0"

echo.请确保此文件在*\Counter-Strike Global Offensive\game\csgo\cfg\CSRM目录当中
REM 检查是否在CSRM文件夹中
for %%I in (.) do set CurrDirName=%%~nxI
if /I not "%CurrDirName%"=="CSRM" (
    color 0C
    echo 请把此文件放进CSRM文件夹中!!!
    echo 请把此文件放进CSRM文件夹中!!!
    echo 请把此文件放进CSRM文件夹中!!!
    echo.
    pause
    exit /b
)

REM 执行setfps并检查退出代码
powershell.exe -ExecutionPolicy Bypass -File ".\install\setfps.ps1"
if %errorlevel% neq 0 (
    echo setfps.ps1 被用户关闭，退出程序
    pause
    exit /b
)

pushd ".\Addon"
powershell.exe -ExecutionPolicy Bypass -File ".\GetCrossHair.ps1"
if %errorlevel% neq 0 (
    echo Addon\GetCrossHair.ps1 被用户关闭，退出程序
    pause
    exit /b
)
popd

REM 检查"完美世界竞技平台"进程是否运行
tasklist /FI "IMAGENAME eq 完美世界竞技平台.exe" 2>NUL | find /I /N "完美世界竞技平台.exe">NUL
if "%ERRORLEVEL%"=="1" (
    CLS
    color 0C
    echo 如果你玩完美平台，请退出程序，运行完美对战平台后启动此文件!!!
    echo 如果你玩完美平台，请退出程序，运行完美对战平台后启动此文件!!!
    echo 如果你玩完美平台，请退出程序，运行完美对战平台后启动此文件!!!
    echo.再次确认！！
    echo.如果你确定不玩完美平台，请按任意键继续
    pause
    REM 运行PowerShell脚本并在完成后退出
    call powershell.exe -ExecutionPolicy Bypass -File ".\install\CSRM_install_withoutwm.ps1"
    if %errorlevel% neq 0 (
        echo CSRM_install_withoutwm.ps1 被用户关闭，退出程序
        pause
        exit /b
    )
) else (
    REM 运行PowerShell脚本并在完成后退出
    call powershell.exe -ExecutionPolicy Bypass -File ".\install\CSRM_install.ps1"
    if %errorlevel% neq 0 (
        echo CSRM_install.ps1 被用户关闭，退出程序
        pause
        exit /b
    )
)

REM 创建桌面快捷方式
echo 正在创建桌面快捷方式...
set "SCRIPT_PATH=%~dp0如果发现轮盘没字了点我.bat"
set "SHORTCUT_NAME=如果发现轮盘没字了点我.lnk"
set "DESKTOP_PATH=%USERPROFILE%\Desktop"

powershell -Command "$WshShell = New-Object -comObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%DESKTOP_PATH%\%SHORTCUT_NAME%'); $Shortcut.TargetPath = '%SCRIPT_PATH%'; $Shortcut.Save()"

if exist "%DESKTOP_PATH%\%SHORTCUT_NAME%" (
    echo 快捷方式创建成功！
) else (
    echo 快捷方式创建失败。
)

echo 已结束
pause
exit /b