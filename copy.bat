@echo off
set addons="D:\World of Warcraft\_classic_\Interface\AddOns\CEPGP-Zulu"

if not exist %addons% MD %addons%

for %%f in (*.toc *.xml *.lua) do copy /y %%f %addons%\%%f >NUL

echo Done
