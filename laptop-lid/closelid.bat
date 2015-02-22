@ECHO OFF
setlocal enableextensions enabledelayedexpansion

FOR /F "delims=," %%i in (C:\NRPortbl\officepoints.txt) do (
   SET bHOSTUP=0
   ping -n 1 %%i | find "TTL=" > NUL && SET bHOSTUP=1
   IF !bHOSTUP! equ 1 GOTO INOFFICE
)

GOTO OUTOFFICE

:INOFFICE
msg * /time:2 "Machine is in office. Closing lid will not put laptop to sleep". 
REM powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
REM powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0 
GOTO EOF

:OUTOFFICE
msg /time:2 * "Machine is not in office. Closing lid will put laptop to sleep". 
REM powercfg -setacvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1
REM powercfg -setdcvalueindex 381b4222-f694-41f0-9685-ff5bb260df2e 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 1
GOTO EOF

:EOF
exit /B