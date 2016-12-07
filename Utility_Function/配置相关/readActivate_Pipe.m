function Activate_Status = readActivate_Pipe()
% �ڲ����������ڶ���Ԥ��������Ϣ
home = getphmpath('home');
inipath = [home, '\Activate_Pipe.ini'];
inipath = alterPath( inipath );

fid = fopen(inipath, 'r');
if fid==-1
    errorlog(['�������ļ�',inipath,'ʧ�ܣ�']);
end
str = mydeblank(fgetl(fid)); % �ӵ�һ�ж�ȡ����
fclose(fid);
info = strsplit(' ', str);

Activate_Status = containers.Map('KeyType', 'char', 'ValueType', 'char');

for i=1:2:numel(info)
    switch info{i}
        case 'Water'
            Activate_Status('Water') = info{i+1};
        case 'Sewage'
            Activate_Status('Sewage') = info{i+1};
        case 'Rain'
            Activate_Status('Rain') = info{i+1};
        case 'Gas'
            Activate_Status('Gas') = info{i+1};
        case 'Heat'
            Activate_Status('Heat') = info{i+1};
    end
end
