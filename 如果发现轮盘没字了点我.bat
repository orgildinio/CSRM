@echo off

REM 检查是否在CSRM文件夹中
for %%I in (.) do set CurrDirName=%%~nxI
if /I not "%CurrDirName%"=="CSRM" (
    color 0C
    echo 请把此文件放进CSRM文件夹中!!!
    echo.请把此文件放进CSRM文件夹中!!!
    echo.请把此文件放进CSRM文件夹中!!!
    echo.请确保此文件在*\Counter-Strike Global Offensive\game\csgo\cfg\CSRM目录当中
    echo.
    pause
    exit /b
)

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
    call powershell.exe -ExecutionPolicy Bypass -File ".\install\CSRM_install_withoutwm_only_Resource.ps1"
    echo 已结束
    pause
    exit /b
)

REM 运行PowerShell脚本并在完成后退出
call powershell.exe -ExecutionPolicy Bypass -File ".\install\CSRM_install_only_Resource.ps1"
echo 已结束
pause