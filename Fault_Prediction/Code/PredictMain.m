function PredictMain( conn )

% 这是故障诊断的最终函数
% 给定数据库连接conn后，诊断所有管线的故障，并写入数据库
tablename = 'YJ_WARNING_FORECAST';
% predictTime 使用全局变量，否则开始和结束的时间会不一样
global predictTime
nt = now;
predictTime = datestr(nt,31);
% 验证预测结果是否正确
writelog('验证上一次的预测结果是否正确\n\n', true);
Val_Pre_Result(); 

AS = readActivate_Pipe(); % 从外部读入各类管线的激活状态

% 1、给水
if strcmp(AS.Water, 'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>给水管线\n\n', true);
    data2write = Fault_Predict( conn, 'Water' );
    % WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库/39秒
    ImportTxt2DB( tablename, 'Water' ); % 将本地的txt导入数据库（速度比前者快很多）/1.33秒
end
    
% 2、污水
if strcmp(AS.Sewage, 'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>污水管线\n\n', true);
    data2write = Fault_Predict( conn, 'Sewage' );
    ImportTxt2DB( tablename, 'Sewage' );
end

% 3、雨水
if strcmp(AS.Rain, 'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>雨水管线\n\n', true);
    data2write = Fault_Predict( conn, 'Rain' );
    ImportTxt2DB( tablename, 'Rain' );
end

% 4、燃气
if strcmp(AS.Gas, 'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>燃气管线\n\n', true);
    data2write = Fault_Predict( conn, 'Gas' );
    ImportTxt2DB( tablename, 'Gas' );
end

% 5、热力
if strcmp(AS.Heat, 'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>热力管线\n\n', true);
    data2write = Fault_Predict( conn, 'Heat' );
    ImportTxt2DB( tablename, 'Heat' );
end






