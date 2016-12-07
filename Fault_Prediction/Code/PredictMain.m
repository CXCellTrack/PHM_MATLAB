function PredictMain( conn )

% ���ǹ�����ϵ����պ���
% �������ݿ�����conn��������й��ߵĹ��ϣ���д�����ݿ�
home = getphmpath('home');
DB = read_DBinfo([home,'\DBinfo.ini']);
tablename = 'YJ_WARNING_FORECAST';
% ��֤Ԥ�����Ƿ���ȷ
Val_Pre_Result( DB ); 

AS = readActivate_Pipe(); % ���ⲿ���������ߵļ���״̬

% 1����ˮ
if AS.isKey('Water') && strcmp(AS('Water'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������Ԥ��>>>>>>>>>>��ˮ����\n\n', true);
    data2write = Fault_Predict( conn, 'Water' );
    % WriteIntoDB( conn, data2write, tablename ); % ��data�������ݿ�/39��
    ImportTxt2DB( DB, tablename, 'Water' ); % �����ص�txt�������ݿ⣨�ٶȱ�ǰ�߿�ࣩܶ/1.33��
end
    
% 2����ˮ
if AS.isKey('Sewage') && strcmp(AS('Sewage'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������Ԥ��>>>>>>>>>>��ˮ����\n\n', true);
    data2write = Fault_Predict( conn, 'Sewage' );
    ImportTxt2DB( DB, tablename, 'Sewage' );
end

% 3����ˮ
if AS.isKey('Rain') && strcmp(AS('Rain'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������Ԥ��>>>>>>>>>>��ˮ����\n\n', true);
    data2write = Fault_Predict( conn, 'Rain' );
    ImportTxt2DB( DB, tablename, 'Rain' );
end

% 4��ȼ��
if AS.isKey('Gas') && strcmp(AS('Gas'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������Ԥ��>>>>>>>>>>ȼ������\n\n', true);
    data2write = Fault_Predict( conn, 'Gas' );
    ImportTxt2DB( DB, tablename, 'Gas' );
end

% 5������
if AS.isKey('Heat') && strcmp(AS('Heat'),'on') % ״̬Ϊonʱ�Ž��в���
    writelog('��������Ԥ��>>>>>>>>>>��������\n\n', true);
    data2write = Fault_Predict( conn, 'Heat' );
    ImportTxt2DB( DB, tablename, 'Heat' );
end






