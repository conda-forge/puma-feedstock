@echo on

:: CMakeLists.txt splices CONDA_PREFIX into strings, where a backslash would be
:: read as an escape, so it gets forward slashes.
set "PUMA_PREFIX=%LIBRARY_PREFIX:\=/%"

cmake -S cpp -B build -G Ninja %CMAKE_ARGS% ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D CONDA_PREFIX=%PUMA_PREFIX% ^
      -D CMAKE_INSTALL_PREFIX=%PUMA_PREFIX%
if errorlevel 1 exit 1

cmake --build build --parallel %CPU_COUNT% -- -k 0
if errorlevel 1 exit 1

cmake --install build
if errorlevel 1 exit 1

del "%LIBRARY_BIN%\pumaX_main.exe"
if errorlevel 1 exit 1
