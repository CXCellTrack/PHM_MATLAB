@echo off

del %cd%\Sewage\data\mat\NSM_Sewage.mat

del %cd%\Sewage\data\mat\bnetCPD_Sewage.mat

echo "ԭ������ɾ��!"

rem pause

ping localhost -n 3 >nul

exit
