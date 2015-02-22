REM Run this in a folder full of roaming profiles (of format username.v2)
REM This script will process each folder and if the context under which it is running is unable to view ACLs of the folder, it will add the BUILTIN\Administrators group to the ACL

@ECHO OFF
setlocal EnableDelayedExpansion

FOR /d %%D in ("*.v2") DO (
  echo Processing %%D
  REM FOR /F "delims=." %%U in ('echo %%D') DO echo User is %%U
  icacls %%D /Q 1> nul 2> nul
  IF !errorlevel! EQU 5 (
    echo    Will fix %%D
    echo    Taking ownership of %%D
    REM takeown /A /F %%D
    
    echo    Granting Administrators full control to %%D
    REM icacls %%D /grant BUILTIN\Administrators:F /T 1> nul 2> nul
    
    echo    Taking ownership of all sub-folders of %%D
    REM takeown /A /F %%D\* /R /D Y
    
    echo    Enabling inheritance on sub-folders of %%D
    REM icacls %%D\* /inheritance:e /T 1> nul 2> nul
  )
)