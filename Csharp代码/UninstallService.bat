
@echo off

rem ֹͣwindows����
rem ж��windows����

net stop PHM 

%PHM_HOME%\Csharp����\InstallUtil.exe /u %PHM_HOME%\Csharp����\WindowsServicePHM\WindowsServicePHM\bin\Debug\WindowsServicePHM.exe /logfile=%PHM_HOME%\Csharp����\InstallService.log

rem pause