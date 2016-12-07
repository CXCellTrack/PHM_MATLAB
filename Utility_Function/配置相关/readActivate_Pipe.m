function Activate_Status = readActivate_Pipe()
% 内部函数：用于读入预测设置信息
home = getphmpath('home');
inipath = [home, '\Activate_Pipe.ini'];
inipath = alterPath( inipath );

fid = fopen(inipath, 'r');
if fid==-1
    errorlog(['打开配置文件',inipath,'失败！']);
end
str = mydeblank(fgetl(fid)); % 从第一行读取参数
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
