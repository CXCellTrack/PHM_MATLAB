@echo 首次运行时需要建立相关表格、序列、触发器

@echo off
echo.
echo 警告！运行此脚本会重建所有的表格、序列、触发器
echo.
set /p ans=是否继续运行 y/[n]		

if not defined ans exit

if %ans%==y (
	goto next 
)else (
	exit
)

:next

set command=sqlplus scott/chenxu@phm

rem ------------------------- 给水------------------------- 
@echo 新建表格

%command% @"%diagpath%\Water\data\sql\create_diag_result_water.sql

%command% @"%evalpath%\Water\data\sql\create_health_eval_water.sql

%command% @"%predictpath%\Water\data\sql\create_predict_result_water.sql

@echo 新建序列

%command% @"%phm_home%\序列触发器sql脚本\create_sequence.sql

@echo 新建触发器

%command% @"%phm_home%\序列触发器sql脚本\create_trigger.sql


rem ------------------------- 污水------------------------- 






pause>nul