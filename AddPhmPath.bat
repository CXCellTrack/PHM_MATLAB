@echo ��� PHM_HOME ϵͳ���� 
@echo off
rem ע�Ⲣ���û�������
rem ע��xxx=XXX�м�һ�����ܼӿո񣡷���ᱨ��

set regpath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
rem set regpath=HKEY_CURRENT_USER\Environment

rem ע�������ӵ�ϵͳ���������������ӵ��û����������Ҳ�����
rem --------------------------------------------- 

set PHM_HOME=%cd%

reg add "%regpath%" /v PHM_HOME /d %PHM_HOME% /f
rem ---------------------------------------------

set diagpath=%PHM_HOME%\Fault_Diagnosis

reg add "%regpath%" /v diagpath /d %diagpath% /f
rem ---------------------------------------------

set predictpath=%PHM_HOME%\Fault_Prediction

reg add "%regpath%" /v predictpath /d %predictpath% /f
rem ---------------------------------------------

set evalpath=%PHM_HOME%\Health_Evaluation

reg add "%regpath%" /v evalpath /d %evalpath% /f
rem ---------------------------------------------

set rulpath=%PHM_HOME%\RUL_Prediction

reg add "%regpath%" /v rulpath /d %rulpath% /f
rem ---------------------------------------------


rem ɾ��ϵͳ���� reg delete "%regpath%" /v "%evname%"  /f

pause
rem ��ͣ������ʾ���밴����������� pause>nul
 
 
