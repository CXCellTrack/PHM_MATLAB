
@echo off

rem 停止windows服务
rem 卸载windows服务

net stop PHM 

%PHM_HOME%\Csharp代码\InstallUtil.exe /u %PHM_HOME%\Csharp代码\WindowsServicePHM\WindowsServicePHM\bin\Debug\WindowsServicePHM.exe /logfile=%PHM_HOME%\Csharp代码\InstallService.log

rem pause