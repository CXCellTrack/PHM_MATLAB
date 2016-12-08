function Activate_Status = readActivate_Pipe()
% 内部函数：用于读入预测设置信息
home = getphmpath('home');
inipath = [home, '\Activate_Pipe.ini'];

if ~exist(inipath, 'file')
    errorlog(['打开配置文件', alterPath(inipath), '失败！']);
end

Activate_Status = read_conf(inipath);
