@echo off

echo Building ASM console calculator...

set OBJS=main.obj app.obj state.obj console_io.obj menus.obj parser.obj formatter.obj result_output.obj dec_ops.obj int_ops.obj bit_ops.obj convert.obj

for %%F in (main app state console_io menus parser formatter result_output dec_ops int_ops bit_ops convert) do (
    echo Assembling %%F.asm...
    nasm -f win64 %%F.asm -o %%F.obj
    if errorlevel 1 (
        echo Failed to build %%F.asm
        pause
        exit /b
    )
)

echo Linking...

gcc -nostdlib -Wl,-e,mainCRTStartup -Wl,--subsystem,console %OBJS% -lkernel32 -o calculator.exe
if errorlevel 1 (
    echo GCC LINK FAILED
    pause
    exit /b
)

del /q %OBJS% >nul 2>nul

echo Build completed successfully.
pause
