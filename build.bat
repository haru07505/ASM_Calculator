@echo off

echo Building Assembly files...

nasm -f win64 calc_core.asm -o calc_core.obj
if errorlevel 1 (
    echo Failed to build calc_core.asm
    pause
    exit /b
)

nasm -f win64 basic_ops.asm -o basic_ops.obj
if errorlevel 1 (
    echo Failed to build basic_ops.asm
    pause
    exit /b
)

nasm -f win64 mul_div_ops.asm -o mul_div_ops.obj
if errorlevel 1 (
    echo Failed to build mul_div_ops.asm
    pause
    exit /b
)

nasm -f win64 advanced_ops.asm -o advanced_ops.obj
if errorlevel 1 (
    echo Failed to build advanced_ops.asm
    pause
    exit /b
)

echo Linking...

gcc main.c calc_core.obj basic_ops.obj mul_div_ops.obj advanced_ops.obj -o calculator.exe
if errorlevel 1 (
    echo GCC LINK FAILED
    pause
    exit /b
)

echo Build completed successfully.
pause