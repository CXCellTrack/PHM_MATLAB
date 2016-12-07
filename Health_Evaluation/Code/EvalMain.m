function EvalMain( conn )

% 这是健康度评估的最终函数
% 给定数据库连接conn后，计算所有管线的健康度，并写入数据库
tablename = 'YJ_WARNING_HEALTH';
AS = readActivate_Pipe(); % 从外部读入各类管线的激活状态

% 1、给水
if AS.isKey('Water') && strcmp(AS('Water'),'on') % 状态为on时才进行操作
    writelog('启动健康度评估>>>>>>>>>>给水管线\n\n', true); 
    data2write = Health_Eval('Water');
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 2、污水
if AS.isKey('Sewage') && strcmp(AS('Sewage'),'on') % 状态为on时才进行操作
    writelog('启动健康度评估>>>>>>>>>>污水管线\n\n', true); 
    data2write = Health_Eval('Sewage');
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 3、雨水
if AS.isKey('Rain') && strcmp(AS('Rain'),'on') % 状态为on时才进行操作
    writelog('启动健康度评估>>>>>>>>>>雨水管线\n\n', true); 
    data2write = Health_Eval('Rain');
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 4、燃气
if AS.isKey('Gas') && strcmp(AS('Gas'),'on') % 状态为on时才进行操作
    writelog('启动健康度评估>>>>>>>>>>燃气管线\n\n', true); 
    data2write = Health_Eval('Gas');
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 5、热力
if AS.isKey('Heat') && strcmp(AS('Heat'),'on') % 状态为on时才进行操作
    writelog('启动健康度评估>>>>>>>>>>热力管线\n\n', true); 
    data2write = Health_Eval('Heat');
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end





writelog('************************************************************\n');
writelog('************************************************************\n');
writelog('==========================================\n\n');



