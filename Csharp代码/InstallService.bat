@echo off
rem ��װwindows����
rem ����windows����Ϊ������
rem ����windows����

%PHM_HOME%\Csharp����\InstallUtil.exe %PHM_HOME%\Csharp����\WindowsServicePHM\WindowsServicePHM\bin\Debug\WindowsServicePHM.exe /logfile=%PHM_HOME%\Csharp����\InstallService.log

sc config PHM start= demand

rem ����������ʽ��demand �ֶ���auto �Զ���disable ���ã�"start="������Ҫ��һ���ո�

net start PHM

rem pause>nul