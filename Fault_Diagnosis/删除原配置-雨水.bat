@echo off

del %cd%\Rain\data\mat\NSM_Rain.mat

del %cd%\Rain\data\mat\bnetCPD_Rain.mat

echo "Ô­ÅäÖÃÒÑÉ¾³ý!"

rem pause

ping localhost -n 3 >nul

exit
