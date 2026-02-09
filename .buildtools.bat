@echo off
setlocal enabledelayedexpansion

:: prerequisites
winget list --id BuildTools > NUL && (
    echo BuildTools found
) || (
    echo [^^!] BuildTools NOT found.
    echo.
    echo Available packages found via winget:
    echo.
    winget search BuildTools
    echo.
    echo Download the official installer from:
    echo    https://aka.ms/vs/stable/vs_BuildTools.exe
    exit /b 1
)
:: check vswhere
winget list --id Microsoft.VisualStudio.Locator > NUL && (
    set QUERY=vswhere -latest -products * ^
            -requires Microsoft.VisualStudio.Product.BuildTools ^
            -property installationPath
    for /f "usebackq tokens=*" %%i in (`!QUERY!`) do (
        set "BT_PATH=%%i"
    )
    if defined BT_PATH (
        echo [OK] BuildTools Path: "!BT_PATH!"
        set "VSD_BAT=!BT_PATH!\Common7\Tools\VsDevCmd.bat"
    ) else (
        echo [^^!] BuildTools Path not found via vswhere.
        exit /b 1
    )
) || (
    winget search --id Microsoft.VisualStudio.Locator
    winget install --id Microsoft.VisualStudio.Locator
    exit /b 0
)

endlocal & call "%VSD_BAT%" -host_arch=x64 -arch=x64 %*