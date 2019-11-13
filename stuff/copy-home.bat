@echo off
set addons="D:\World of Warcraft\_classic_\Interface\AddOns\CEPGP-Zulu"

if not exist %addons% md %addons%

for %%f in (..\*.toc ..\*.xml ..\*.lua) do copy /y %%f %addons%\%%~nf%%~xf >NUL

echo Done
