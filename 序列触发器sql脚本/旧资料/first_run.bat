@echo �״�����ʱ��Ҫ������ر�����С�������

@echo off
echo.
echo ���棡���д˽ű����ؽ����еı�����С�������
echo.
set /p ans=�Ƿ�������� y/[n]		

if not defined ans exit

if %ans%==y (
	goto next 
)else (
	exit
)

:next

set command=sqlplus scott/chenxu@phm

rem ------------------------- ��ˮ------------------------- 
@echo �½����

%command% @"%diagpath%\Water\data\sql\create_diag_result_water.sql

%command% @"%evalpath%\Water\data\sql\create_health_eval_water.sql

%command% @"%predictpath%\Water\data\sql\create_predict_result_water.sql

@echo �½�����

%command% @"%phm_home%\���д�����sql�ű�\create_sequence.sql

@echo �½�������

%command% @"%phm_home%\���д�����sql�ű�\create_trigger.sql


rem ------------------------- ��ˮ------------------------- 






pause>nul