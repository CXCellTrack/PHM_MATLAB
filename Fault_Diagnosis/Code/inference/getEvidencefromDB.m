function evidence = getEvidencefromDB( conn, bnetCPD, info, pipeclass, n_fault )


switch pipeclass 
    % 给水查询语句
    case 'Water'
        tablename = 'AD_SL_NOISE';
        quire_sql = sprintf(['SELECT DENSEDATA FROM ',...
            '(SELECT DENSEDATA,UPTIME FROM %s WHERE DEVCODE=''%s'' ORDER BY UPTIME DESC) ',...
            'WHERE ROWNUM=1'], tablename, 'just_for_re');
    % 污水查询语句 
    case 'Sewage'
        tablename = 'AD_DJ_LIQUID';
        quire_sql = sprintf(['SELECT LIQUIDDATA FROM ',...
            '(SELECT LIQUIDDATA,UPTIME FROM %s WHERE DEVCODE=''%s'' ORDER BY UPTIME DESC) ',...
            'WHERE ROWNUM=1'], tablename, 'just_for_re');
    % 雨水查询语句
    case 'Rain'
        tablename = 'AD_DJ_LIQUID';
        quire_sql = sprintf(['SELECT LIQUIDDATA FROM ',...
            '(SELECT LIQUIDDATA,UPTIME FROM %s WHERE DEVCODE=''%s'' ORDER BY UPTIME DESC) ',...
            'WHERE ROWNUM=1'], tablename, 'just_for_re');
    case 'Gas'
        tablename = '...';
end

% 证据cell
evidence = cell(numel(bnetCPD.CPD),1);

for h=1:numel(info.sensor)
    sensorname = info.sensor(h).ATTRIBUTE.name;
%     if ~ischar(sensorname) % sensorname如果是纯数字会被读成数字，需要转成char 
%         sensorname = num2str(sensorname); % 已经在刚读入info时进行了转换
%     end

    % 将quire_sql中的字符串‘just_for_re’替换为sensorname
    sql = strrep(quire_sql, 'just_for_re', sensorname);
    
    % sql语句找出最近的一次uptime，使用该记录进行诊断
    DATA = fetch_data(conn, sql);
    sid = h + n_fault; % sensor id 的推出方式
    
    % 如果没找到数据则设置观测为其正常时候的均值，即默认正常
    if strcmp(DATA{1},'No Data')
        tmp = struct(bnetCPD.CPD{sid});
        tmp = reshape(tmp.mean, 1, []);
        evidence{sid} = tmp(1);
        continue
    end
    % 输入证据
    evidence{sid} = str2double(DATA);
end
    












