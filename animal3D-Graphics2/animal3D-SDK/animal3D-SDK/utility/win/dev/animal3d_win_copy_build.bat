::Utility script to copy build files.
::By Dan Buckstein
@echo off
:: create output directory in case it does not exist yet
:: write to dummy file and perform copy
:: also create asset data directory
cd "%ANIMAL3D_SDK%"
mkdir %2
mkdir %5
set dstfile="%~2\%~4"
@echo ANIMAL3D_SDK>%dstfile%
call ".\utility\win\dev\animal3d_win_copy.bat" %1 %2 %3 %4