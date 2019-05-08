::Utility script to launch SDK in latest version of Visual Studio.
::By Dan Buckstein

if exist "%VS150COMNTOOLS%" (
rem VISUAL STUDIO 2017 IF PATH EXISTS
	set a3vstoolsdir="%VS150COMNTOOLS%"
	set a3vslaunchpath="%VS150COMNTOOLS%..\IDE\devenv"
	set a3platformtoolset=v141
) else if exist "%VS140COMNTOOLS%" (
rem VISUAL STUDIO 2015 IF PATH EXISTS
	set a3vstoolsdir="%VS140COMNTOOLS%"
	set a3vslaunchpath="%VS140COMNTOOLS%..\IDE\devenv"
	set a3platformtoolset=v140
) else if exist "%VS120COMNTOOLS%" (
rem VISUAL STUDIO 2013 IF PATH EXISTS
	set a3vstoolsdir="%VS120COMNTOOLS%"
	set a3vslaunchpath="%VS120COMNTOOLS%..\IDE\devenv"
	set a3platformtoolset=v120
) else if exist "%VS110COMNTOOLS%" (
rem VISUAL STUDIO 2012 IF PATH EXISTS
	set a3vstoolsdir="%VS110COMNTOOLS%"
	set a3vslaunchpath="%VS110COMNTOOLS%..\IDE\devenv"
	set a3platformtoolset=v110
)

if exist %a3vstoolsdir% (
	start %a3vslaunchpath% "%ANIMAL3D_SDK%project\VisualStudio\_SLN\%~1\%~1.sln"
) else (
	echo A3 ERROR: Could not locate compatible version of Visual Studio.
)
