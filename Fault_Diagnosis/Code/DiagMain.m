function DiagMain( conn )

% ���ǹ�����ϵ����պ���
% �������ݿ�����conn��������й��ߵĹ��ϣ���д�����ݿ�
tablename = 'YJ_WARNING_DIAGNOSIS';
AS = readActivate_Pipe(); % ���ⲿ���������ߵļ���״̬���ֵ����ͣ�

% record_id ʹ��ȫ�ֱ���������ʼ�ͽ�����id�᲻һ��
global recordId diagTime
nt = now;
diagTime = datestr(nt,31);
recordId = strrep(datestr(nt,30),'T','');
recordId = recordId(1:end-2);


% 1����ˮ
if strcmp(AS.Water, 'on') % ״̬Ϊonʱ�Ž��в���
    writelog('�����������>>>>>>>>>>��ˮ����\n\n', true);
    data2write = Diag( conn, 'Water' );
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 2����ˮ
if strcmp(AS.Sewage, 'on') % ״̬Ϊonʱ�Ž��в���
    writelog('�����������>>>>>>>>>>��ˮ����\n\n', true);
    data2write = Diag( conn, 'Sewage' );
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 3����ˮ
if strcmp(AS.Rain, 'on') % ״̬Ϊonʱ�Ž��в���
    writelog('�����������>>>>>>>>>>��ˮ����\n\n', true);
    data2write = Diag( conn, 'Rain' );
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 4��ȼ��
if strcmp(AS.Gas, 'on') % ״̬Ϊonʱ�Ž��в���
    writelog('�����������>>>>>>>>>>ȼ������\n\n', true);
    data2write = Diag( conn, 'Gas' );
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end

% 5������
if strcmp(AS.Heat, 'on') % ״̬Ϊonʱ�Ž��в���
    writelog('�����������>>>>>>>>>>��������\n\n', true);
    data2write = Diag( conn, 'Heat' );
    WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�
end





writelog('************************************************************\n');
writelog('************************************************************\n');
writelog('==========================================\n\n');





