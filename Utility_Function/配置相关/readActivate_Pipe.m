function Activate_Status = readActivate_Pipe()
% �ڲ����������ڶ���Ԥ��������Ϣ
home = getphmpath('home');
inipath = [home, '\Activate_Pipe.ini'];

if ~exist(inipath, 'file')
    errorlog(['�������ļ�', alterPath(inipath), 'ʧ�ܣ�']);
end

Activate_Status = read_conf(inipath);
