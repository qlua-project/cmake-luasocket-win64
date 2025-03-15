@echo off
setlocal

call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars64.bat"

set "CMAKE_BINARY_DIR=cmake-build-release-x64"
if /I NOT "%1"=="" set "CMAKE_BINARY_DIR=%1"
set "DUMPBIN_DIR=%CMAKE_BINARY_DIR:build=dump%"

pushd %~dp0
mkdir %DUMPBIN_DIR%

pushd %DUMPBIN_DIR%

    dumpbin /headers ..\%CMAKE_BINARY_DIR%\socket\core.dll > socket.core.dll.headers.txt
    dumpbin /exports ..\%CMAKE_BINARY_DIR%\socket\core.dll > socket.core.dll.exports.txt
    dumpbin /dependents ..\%CMAKE_BINARY_DIR%\socket\core.dll > socket.core.dll.dependents.txt
    dumpbin /imports ..\%CMAKE_BINARY_DIR%\socket\core.dll > socket.core.dll.imports.txt

    dumpbin /headers ..\%CMAKE_BINARY_DIR%\mime\core.dll > mime.core.dll.headers.txt
    dumpbin /exports ..\%CMAKE_BINARY_DIR%\mime\core.dll > mime.core.dll.exports.txt
    dumpbin /dependents ..\%CMAKE_BINARY_DIR%\mime\core.dll > mime.core.dll.dependents.txt
    dumpbin /imports ..\%CMAKE_BINARY_DIR%\mime\core.dll > mime.core.dll.imports.txt

popd
popd

endlocal
