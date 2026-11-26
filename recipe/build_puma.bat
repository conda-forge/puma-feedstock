@echo on

:: The C++ library the GUI links against comes from the libpuma package in the
:: host environment, so BUILD_PREFIX and INSTALL_PREFIX both point at the
:: prefix. qmake wants forward slashes.
set "PUMA_PREFIX=%LIBRARY_PREFIX:\=/%"

:: Replace the vendored QCustomPlot 2.0.0, which predates Qt 6, with the 2.1.1
:: release the recipe fetches as a second source.
for %%f in (qcustomplot.h qcustomplot.cpp GPL.txt) do (
    copy /Y "qcustomplot-2.1.1\%%f" "gui\src\Utilities\qcustomplot\%%f"
    if errorlevel 1 exit 1
)

cd gui\build
if errorlevel 1 exit 1

:: Without debug_and_release the executable lands next to the Makefile and
:: "nmake install" picks it up from there.
qmake6 "CONFIG+=release" "CONFIG-=debug_and_release" ^
      BUILD_PREFIX=%PUMA_PREFIX% ^
      INSTALL_PREFIX=%PUMA_PREFIX%
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
