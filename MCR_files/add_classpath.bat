@echo off
echo writtren by cx 2015.10.22

echo.
echo �˽ű����ڽ�oracle���ݿ�����ojdbc6.jar�ĵ�ַ
echo д��MCR(Matlab Compile Runtime)��classpath��

echo.
echo ʹ��ǰ��ȷ���˽ű���ojdbc6.jar��λ��MCR��Ŀ¼(���磺D:\xxx\v716\)��

echo.
echo ȷ��������밴y�����������밴n�˳�:

set /p ans=[y]/n	

rem ���ֱ�Ӱ���enter����ans�����޶��壬�൱��yes�����ֱ��ת��:do���в���
if not defined ans goto :do

rem ����n���˳�bat
if /i %ans%==n exit



:do

set matlabroot=%cd%

set txtpath=%matlabroot%\toolbox\local\classpath.txt

set qudong=%matlabroot%\ojdbc6.jar


rem ����ļ��Ƿ����
if not exist %txtpath% (
	echo �����Ҳ��� %matlabroot%\toolbox\local\classpath.txt
	echo �뽫���������ļ�����MCR��Ŀ¼�£�
	pause
	exit
)
if not exist %qudong% (
	echo �����Ҳ��� %matlabroot%\ojdbc6.jar
	echo �뽫oracle���ݿ������ļ�ojdbc6.jar����MCR��Ŀ¼�£�
	pause
	exit
)


rem ʹ��>>��txt��׷���ļ�

echo. >>%txtpath%

echo $matlabroot/ojdbc6.jar >>%txtpath%

echo.
echo д��classpath�ɹ���
echo ��������˳�...
pause >nul






