@ECHO OFF
REM Run this in a folder full of roaming profiles (of format username.v2)
REM This script will process each folder and if the context under which it is running is unable to view ACLs of the folder, it will add the BUILTIN\Administrators group to the ACL

setlocal EnableDelayedExpansion
set DOMAIN=%USERDOMAIN%

REM For loop runs through each file/ folder of name *.V2
REM Note to self: Use something like 'dir /A:D *.v2' below if you want to limit to folders only
FOR /d %%D in ("*.v2") DO (
  echo Processing %%D
  
  REM Find the user to whom the profile belongs (so we can set ownership back once done)
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