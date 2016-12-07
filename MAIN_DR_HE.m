function MAIN_DR_HE
%
% 故障诊断和健康度评估部分
% 这是一个通用函数，即分析所有的管线类型，并全部写入数据库
% 这个函数在windows服务中定为1小时执行一次
% -------------------------------------------
writelog('启动PHM软件系统...\n', true, 'rewrite');
% 1、连接oracle数据库
conn = link_Oracle_Database;
% 2、诊断并写入数据库
DiagMain( conn );
% 3、健康度评估并写入数据库
EvalMain( conn );
% end、关闭数据库连接
close(conn);
writelog('数据库连接关闭！\n', 1);

% 创建标记文件
fid = fopen([getphmpath('home'), '\Csharp代码\done.flag'], 'w+');
fclose(fid);

% 设置数据库读取格式
% setdbprefs('datareturnformat', 'cellarray')
% setdbprefs('datareturnformat', 'numeric')













