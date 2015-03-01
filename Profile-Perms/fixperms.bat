@ECHO OFF
REM Run this in a folder full of roaming profiles (of format username.v2)
REM This script will process each folder and if the context under which it is running is unable to view ACLs of the folder, it will add the BUILTIN\Administrators group to the ACL

REM Setting EnabledDelayedExpansion will cause each variable to be expanded at execution time rather than at parse time
REM Delayed Expansion is required because (1) I set the %USER% variable below and that does not take effect unless I do delayed expansion
REM See http://stackoverflow.com/questions/691047/batch-file-variables-initialized-in-a-for-loop
REM (2) the %ERRORLEVEL% variable is not captured from icacls below
REM See http://stackoverflow.com/questions/3088712/errorlevel-of-command-executed-by-batch-for-loop
setlocal EnableDelayedExpansion
set DOMAIN=%USERDOMAIN%

REM For loop runs through each file/ folder of name *.V2
REM Note to self: Use something like 'dir /A:D *.v2' below if you want to limit to folders only
FOR /d %%D in ("*.v2") DO (
  echo Processing %%D
  
  REM Find the user to whom the profile belongs (so we can set ownership back once done)
  REM ECHO %%D emits the folder name - of format username.v2
  REM FOR /f is for reading a text file (or a single line like the output of echo)
  REM "delims=." splits the text along the dot, resulting in two tokens; %U is assigned the first, %V the second, and so on
  REM By default only the first token of each line is selected (you can select any other token or a range via "tokens=x,y,z delims=."
  FOR /F "delims=." %%U in ('echo %%D') DO set USER=%%U
  
  REM Try to find permissions; if ERRORLEVEL 0 then all is good; 5 implies Access Denied
  icacls %%D /Q 1> nul 2> nul
  IF !errorlevel! EQU 5 (
    echo    Profile %%D needs fixing
    
    echo    Taking ownership of %%D
    takeown /A /F %%D
    
    echo    Granting Administrators full control to %%D
    icacls %%D /grant BUILTIN\Administrators:F /T 1> nul 2> nul
    
    echo    Taking ownership of all sub-folders of %%D
    takeown /A /F %%D\* /R /D Y
    
    echo    Enabling inheritance on sub-folders of %%D
    icacls %%D\* /inheritance:e /T 1> nul 2> nul
    
    echo    Setting owner back to %DOMAIN%\!USER!
    icacls %%D /setowner %DOMAIN%\%USER%
  )
)