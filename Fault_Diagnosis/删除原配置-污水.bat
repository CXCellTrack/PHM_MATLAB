@echo off

del %cd%\Sewage\data\mat\NSM_Sewage.mat

del %cd%\Sewage\data\mat\bnetCPD_Sewage.mat

echo "Ô­ÅäÖÃÒÑÉ¾³ý!"

rem pause

ping localhost -n 3 >nul

exit
