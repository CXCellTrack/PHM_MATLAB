@echo off

del %cd%\Water\data\mat\NSM_Water.mat

del %cd%\Water\data\mat\bnetCPD_Water.mat

echo "Ô­ÅäÖÃÒÑÉ¾³ý!"

rem pause

ping localhost -n 3 >nul

exit
