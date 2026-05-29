@echo off

echo DEC real: 10.5 + 2.25
(
echo 1
echo 1
echo 10.5
echo 2.25
echo 0
echo 0
) | calculator.exe

echo HEX integer: A + 2, then convert result to BIN
(
echo 2
echo 1
echo A
echo 2
echo 2
echo 3
echo 0
echo 0
) | calculator.exe

echo BIN integer: 1010 AND 0011
(
echo 3
echo 5
echo 1010
echo 0011
echo 0
echo 0
) | calculator.exe

echo DEC integer conversion: -10 to HEX
(
echo 4
echo 1
echo -10
echo 0
echo 0
) | calculator.exe

echo HEX two's complement conversion: FFFFFFF6 to DEC
(
echo 4
echo 3
echo FFFFFFF6
echo 0
echo 0
) | calculator.exe

pause
