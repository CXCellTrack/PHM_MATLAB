function cmd = readSVRparam( predict_path, pipe_type )
% �ڲ����������ڶ���SVR������Ϣ
% ע��pipe_type����ĸ��д
switch pipe_type
    case 'Water'
    case 'Sewage'
    case 'Rain'
    case 'Gas'
    case 'Heat'
    otherwise
        errorlog('�������ֻ���� Water��Sewage��Rain��Gas��Heat �е�һ��!');
end
% ����SVRparam.txt��������Ϣ
txtpath = [predict_path, '\', pipe_type, '\data\udf\SVRparam.txt'];
txtpath = alterPath( txtpath );
fid = fopen(txtpath, 'r');
if fid==-1
    errorlog('���ļ�',txtpath,'ʧ�ܣ�');
end
cmd = fgetl(fid); % �ӵ�һ�ж�ȡsvr����
fclose(fid);




