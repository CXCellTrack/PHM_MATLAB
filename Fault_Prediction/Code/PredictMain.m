function PredictMain( conn )

% 这是故障诊断的最终函数
% 给定数据库连接conn后，诊断所有管线的故障，并写入数据库
home = getphmpath('home');
DB = read_DBinfo([home,'\DBinfo.ini']);
tablename = 'YJ_WARNING_FORECAST';
% 验证预测结果是否正确
Val_Pre_Result( DB ); 

AS = readActivate_Pipe(); % 从外部读入各类管线的激活状态

% 1、给水
if AS.isKey('Water') && strcmp(AS('Water'),'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>给水管线\n\n', true);
    data2write = Fault_Predict( conn, 'Water' );
    % WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库/39秒
    ImportTxt2DB( DB, tablename, 'Water' ); % 将本地的txt导入数据库（速度比前者快很多）/1.33秒
end
    
% 2、污水
if AS.isKey('Sewage') && strcmp(AS('Sewage'),'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>污水管线\n\n', true);
    data2write = Fault_Predict( conn, 'Sewage' );
    ImportTxt2DB( DB, tablename, 'Sewage' );
end

% 3、雨水
if AS.isKey('Rain') && strcmp(AS('Rain'),'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>雨水管线\n\n', true);
    data2write = Fault_Predict( conn, 'Rain' );
    ImportTxt2DB( DB, tablename, 'Rain' );
end

% 4、燃气
if AS.isKey('Gas') && strcmp(AS('Gas'),'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>燃气管线\n\n', true);
    data2write = Fault_Predict( conn, 'Gas' );
    ImportTxt2DB( DB, tablename, 'Gas' );
end

% 5、热力
if AS.isKey('Heat') && strcmp(AS('Heat'),'on') % 状态为on时才进行操作
    writelog('启动故障预测>>>>>>>>>>热力管线\n\n', true);
    data2write = Fault_Predict( conn, 'Heat' );
    ImportTxt2DB( DB, tablename, 'Heat' );
end






