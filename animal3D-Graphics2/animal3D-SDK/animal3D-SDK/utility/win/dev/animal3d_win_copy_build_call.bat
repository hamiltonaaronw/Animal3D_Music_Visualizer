::Utility script to call build copy.
::By Dan Buckstein
@echo off
set "calldir=%~dp0"
if not "%stopcopy%"=="YES" (
	call "%calldir%animal3d_win_copy_build.bat" %1 %2 %3 %4 %5
) else (
	echo A3: DEFERRED COPY BUILD...
)