function MAIN_PRE_RUL
%
% 故障预测和剩余寿命预测部分
% 这是一个通用函数，即分析所有的管线类型，并全部写入数据库
% 这个函数在windows服务中定为?天执行一次
% -------------------------------------------
writelog('启动PHM软件系统...\n\n', true, 'rewrite');
% 1、连接oracle数据库
conn = link_Oracle_Database;
% 2、进行故障预警
PredictMain( conn );
% 3、进行剩余寿命预测
% RULMain( conn );
% end、关闭数据库连接
close(conn);
writelog('数据库连接关闭！\n',1);

% 运行sqls_to_run.sql
run_post_sqls('predict')


