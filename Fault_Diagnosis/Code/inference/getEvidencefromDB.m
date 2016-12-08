function evidence = getEvidencefromDB( conn, bnetCPD, info, pipeclass, n_fault )


switch pipeclass 
    % ��ˮ��ѯ���
    case 'Water'
        tablename = 'AD_SL_NOISE';
        quire_sql = sprintf(['SELECT DENSEDATA FROM ',...
            '(SELECT DENSEDATA,UPTIME FROM %s WHERE DEVCODE=''%s'' ORDER BY UPTIME DESC) ',...
            'WHERE ROWNUM=1'], tablename, 'just_for_re');
    % ��ˮ��ѯ��� 
    case 'Sewage'
        tablename = 'AD_DJ_LIQUID';
        quire_sql = sprintf(['SELECT LIQUIDDATA FROM ',...
            '(SELECT LIQUIDDATA,UPTIME FROM %s WHERE DEVCODE=''%s'' ORDER BY UPTIME DESC) ',...
            'WHERE ROWNUM=1'], tablename, 'just_for_re');
    % ��ˮ��ѯ���
    case 'Rain'
        tablename = 'AD_DJ_LIQUID';
        quire_sql = sprintf(['SELECT LIQUIDDATA FROM ',...
            '(SELECT LIQUIDDATA,UPTIME FROM %s WHERE DEVCODE=''%s'' ORDER BY UPTIME DESC) ',...
            'WHERE ROWNUM=1'], tablename, 'just_for_re');
    case 'Gas'
        tablename = '...';
end

% ֤��cell
evidence = cell(numel(bnetCPD.CPD),1);

for h=1:numel(info.sensor)
    sensorname = info.sensor(h).ATTRIBUTE.name;
%     if ~ischar(sensorname) % sensorname����Ǵ����ֻᱻ�������֣���Ҫת��char 
%         sensorname = num2str(sensorname); % �Ѿ��ڸն���infoʱ������ת��
%     end

    % ��quire_sql�е��ַ�����just_for_re���滻Ϊsensorname
    sql = strrep(quire_sql, 'just_for_re', sensorname);
    
    % sql����ҳ������һ��uptime��ʹ�øü�¼�������
    DATA = fetch_data(conn, sql);
    sid = h + n_fault; % sensor id ���Ƴ���ʽ

    cpd_value = struct(bnetCPD.CPD{sid});
    mean_value = reshape(cpd_value.mean, 1, []);
    if strcmp(DATA{1},'No Data')
        % ���û�ҵ����������ù۲�Ϊ������ʱ��ľ�ֵ����Ĭ������
        evidence{sid} = mean_value(1);
    else
        % ����֤�ݣ�֤��Ҫcut��[mean_value(1)��mean_value(2)]֮��
        DATA = str2double(DATA);
        DATA(DATA>mean_value(2)) = mean_value(2);
        DATA(DATA<mean_value(1)) = mean_value(1);
        evidence{sid} = DATA;
    end
end
    












