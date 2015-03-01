REM Batch file I use at work to copy the required files over to a user machine & create a scheduled task that runs as the user when they login

REM Copy to C:\
copy /Y "\\path\to\closelid.bat" C:\
copy /Y "\\path\to\officepoints.txt" C:\

REM Copy the scheduled task file too, replacing as required
powershell -Command "(gc \\path\to\schtask.xml) -replace '--REPLACE--', $("$env:USERDOMAIN" + '\' + "$env:USERNAME") | Out-File -Encoding ASCII C:\schtask.xml"

REM Create the scheduled task & delete the file once done
schtasks /Create /XML "C:\schtask.xml" /TN "Laptop Lid closing"
del /f C:\schtask.xml

REM Run the scheduled task once
schtasks /Run /TN "Laptop Lid closing"
pause