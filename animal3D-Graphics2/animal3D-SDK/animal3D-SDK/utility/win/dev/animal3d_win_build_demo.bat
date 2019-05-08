::Utility script to build project.
::By Dan Buckstein
@echo off
set launchpath=%1
set buildpath=%~2
set buildconfig=%3
set buildswitch=%~4
set projname=%~5
set stopcopy=%~6
set proj="%ANIMAL3D_SDK%project\VisualStudio\%projname%\%projname%.vcxproj"
call %launchpath% %proj% /%buildswitch% %buildconfig%
exit