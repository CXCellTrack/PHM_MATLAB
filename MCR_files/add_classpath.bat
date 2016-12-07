@echo off
echo writtren by cx 2015.10.22

echo.
echo 此脚本用于将oracle数据库驱动ojdbc6.jar的地址
echo 写入MCR(Matlab Compile Runtime)的classpath中

echo.
echo 使用前请确保此脚本与ojdbc6.jar均位于MCR根目录(例如：D:\xxx\v716\)下

echo.
echo 确认无误后请按y继续，否则请按n退出:

set /p ans=[y]/n	

rem 如果直接按下enter，则ans变量无定义，相当于yes，因此直接转到:do进行操作
if not defined ans goto :do

rem 按下n则退出bat
if /i %ans%==n exit



:do

set matlabroot=%cd%

set txtpath=%matlabroot%\toolbox\local\classpath.txt

set qudong=%matlabroot%\ojdbc6.jar


rem 检查文件是否存在
if not exist %txtpath% (
	echo 错误！找不到 %matlabroot%\toolbox\local\classpath.txt
	echo 请将此批处理文件放在MCR根目录下！
	pause
	exit
)
if not exist %qudong% (
	echo 错误！找不到 %matlabroot%\ojdbc6.jar
	echo 请将oracle数据库驱动文件ojdbc6.jar放在MCR根目录下！
	pause
	exit
)


rem 使用>>往txt中追加文件

echo. >>%txtpath%

echo $matlabroot/ojdbc6.jar >>%txtpath%

echo.
echo 写入classpath成功！
echo 按任意键退出...
pause >nul






