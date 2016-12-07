@echo 添加 PHM_HOME 系统变量 
@echo off
rem 注意并非用户变量！
rem 注意xxx=XXX中间一定不能加空格！否则会报错！

set regpath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
rem set regpath=HKEY_CURRENT_USER\Environment

rem 注意必须添加到系统环境变量，如果添加到用户变量中是找不到的
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


rem 删除系统变量 reg delete "%regpath%" /v "%evname%"  /f

pause
rem 暂停但不显示“请按任意键继续” pause>nul
 
 
