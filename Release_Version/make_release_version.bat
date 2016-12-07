@echo off

rem 1������ Csharp���� �е�����
set suc_home=%phm_home%\Csharp����\
set dst_home=%phm_home%\Release_Version\PHM_PIPE\Csharp����\

xcopy %suc_home%*.bat %dst_home% /y
xcopy %suc_home%*.exe %dst_home% /y
xcopy %suc_home%WindowsServicePHM\runbat\bin\Debug\runbat.exe %dst_home%WindowsServicePHM\runbat\bin\Debug\ /y
xcopy %suc_home%WindowsServicePHM\WindowsServicePHM\bin\Debug\WindowsServicePHM.exe %dst_home%WindowsServicePHM\WindowsServicePHM\bin\Debug\ /y


rem 2������ Fault_Diagnosis/Fault_Prediction/Health_Evaluation/MCR files/RUL_Prediction �е�����
set dst_home=%phm_home%\Release_Version\PHM_PIPE\

xcopy %phm_home%\Fault_Diagnosis %dst_home%Fault_Diagnosis\ /e/y
rmdir %dst_home%Fault_Diagnosis\Code /s/q
xcopy %phm_home%\Fault_Prediction %dst_home%Fault_Prediction\ /e/y
rmdir %dst_home%Fault_Prediction\Code /s/q
xcopy %phm_home%\Health_Evaluation %dst_home%Health_Evaluation\ /e/y
rmdir %dst_home%Health_Evaluation\Code /s/q
xcopy %phm_home%\RUL_Prediction %dst_home%RUL_Prediction\ /e/y

xcopy %phm_home%\���д�����sql�ű�\*.sql %dst_home%���д�����sql�ű�\ /y
xcopy %phm_home%\MCR_files %dst_home%\MCR_files\ /e/y
xcopy %phm_home%\*.bat %dst_home% /y
xcopy %phm_home%\*.ini %dst_home% /y


rem 3������ Precompiled EXE �е�����\
set suc_home=%phm_home%\Precompiled_EXE\
set dst_home=%phm_home%\Release_Version\PHM_PIPE\Precompiled_EXE\

xcopy %suc_home%*.bat %dst_home% /y
xcopy %suc_home%linkDB_test\distrib\linkDB_test.exe %dst_home%linkDB_test\distrib\ /y
xcopy %suc_home%PHMdiag\distrib\PHMdiag.exe %dst_home%PHMdiag\distrib\ /y
xcopy %suc_home%PHMpredict\distrib\PHMpredict.exe %dst_home%PHMpredict\distrib\ /y



:pause
ping localhost -n 3 >nul













