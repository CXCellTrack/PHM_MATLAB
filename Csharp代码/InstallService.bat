@echo off
rem 安装windows服务
rem 设置windows服务为自启动
rem 启动windows服务

%PHM_HOME%\Csharp代码\InstallUtil.exe %PHM_HOME%\Csharp代码\WindowsServicePHM\WindowsServicePHM\bin\Debug\WindowsServicePHM.exe /logfile=%PHM_HOME%\Csharp代码\InstallService.log

sc config PHM start= demand

rem 设置启动方式（demand 手动、auto 自动、disable 禁用）"start="后面需要加一个空格！

net start PHM

rem pause>nul