function EvalMain( conn )

% ���ǽ��������������պ���
% �������ݿ�����conn�󣬼������й��ߵĽ����ȣ���д�����ݿ�
tablename = 'YJ_WARNING_HEALTH';
AS = readActivate_Pipe(); % ���ⲿ���������ߵļ���״̬

% 1����ˮ
if AS.isKey('Water') && strcmp(AS('Water'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������������>>>>>>>>>>��ˮ����\n\n', true); 
    data2write = Health_Eval('Water');
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 2����ˮ
if AS.isKey('Sewage') && strcmp(AS('Sewage'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������������>>>>>>>>>>��ˮ����\n\n', true); 
    data2write = Health_Eval('Sewage');
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 3����ˮ
if AS.isKey('Rain') && strcmp(AS('Rain'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������������>>>>>>>>>>��ˮ����\n\n', true); 
    data2write = Health_Eval('Rain');
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 4��ȼ��
if AS.isKey('Gas') && strcmp(AS('Gas'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������������>>>>>>>>>>ȼ������\n\n', true); 
    data2write = Health_Eval('Gas');
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 5������
if AS.isKey('Heat') && strcmp(AS('Heat'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������������>>>>>>>>>>��������\n\n', true); 
    data2write = Health_Eval('Heat');
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end





writelog('************************************************************\n');
writelog('************************************************************\n');
writelog('==========================================\n\n');



