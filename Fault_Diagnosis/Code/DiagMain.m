function DiagMain( conn )

% 这是故障诊断的最终函数
% 给定数据库连接conn后，诊断所有管线的故障，并写入数据库
tablename = 'YJ_WARNING_DIAGNOSIS';
AS = readActivate_Pipe(); % 从外部读入各类管线的激活状态（字典类型）

% record_id 使用全局变量，否则开始和结束的id会不一样
global recordId
nt = now;
recordId = strrep(datestr(nt,30),'T','');
recordId = recordId(1:end-2);


% 1、给水
if AS.isKey('Water') && strcmp(AS('Water'),'on') % 状态为on时才进行操作
    writelog('启动故障诊断>>>>>>>>>>给水管线\n\n', true);
    data2write = Diag( conn, 'Water' );
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 2、污水
if AS.isKey('Sewage') && strcmp(AS('Sewage'),'on') % 状态为on时才进行操作
    writelog('启动故障诊断>>>>>>>>>>污水管线\n\n', true);
    data2write = Diag( conn, 'Sewage' );
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 3、雨水
if AS.isKey('Rain') && strcmp(AS('Rain'),'on') % 状态为on时才进行操作
    writelog('启动故障诊断>>>>>>>>>>雨水管线\n\n', true);
    data2write = Diag( conn, 'Rain' );
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 4、燃气
if AS.isKey('Gas') && strcmp(AS('Gas'),'on') % 状态为on时才进行操作
    writelog('启动故障诊断>>>>>>>>>>燃气管线\n\n', true);
    data2write = Diag( conn, 'Gas' );
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end

% 5、热力
if AS.isKey('Heat') && strcmp(AS('Heat'),'on') % 状态为on时才进行操作
    writelog('启动故障诊断>>>>>>>>>>热力管线\n\n', true);
    data2write = Diag( conn, 'Heat' );
    WriteIntoDB( conn, data2write, tablename ); % 将data插入数据库
end





writelog('************************************************************\n');
writelog('************************************************************\n');
writelog('==========================================\n\n');





