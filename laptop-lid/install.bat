copy /Y "\\vs-mussdata01\LocalData\Rakhesh\Scripts\Laptop-Lid\closelid.bat" C:\NRPortbl
copy /Y "\\vs-mussdata01\LocalData\Rakhesh\Scripts\Laptop-Lid\officepoints.txt" C:\NRPortbl

powershell -Command "(gc \\vs-mussdata01\LocalData\Rakhesh\Scripts\Laptop-Lid\schtask.xml) -replace '--REPLACE--', $("$env:USERDOMAIN" + '\' + "$env:USERNAME") | Out-File -Encoding ASCII C:\NRPortbl\schtask.xml"

schtasks /Create /XML "C:\NRPortbl\schtask.xml" /TN "Laptop Lid closing"
del /f C:\NRPortbl\schtask.xml

schtasks /Run /TN "Laptop Lid closing"
pause