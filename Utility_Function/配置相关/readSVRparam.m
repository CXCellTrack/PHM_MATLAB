function cmd = readSVRparam( predict_path, pipe_type )
% 内部函数：用于读入SVR参数信息
% 注意pipe_type首字母大写
switch pipe_type
    case 'Water'
    case 'Sewage'
    case 'Rain'
    case 'Gas'
    case 'Heat'
    otherwise
        errorlog('输入参数只能是 Water、Sewage、Rain、Gas、Heat 中的一种!');
end
% 读入SVRparam.txt的配置信息
txtpath = [predict_path, '\', pipe_type, '\data\udf\SVRparam.txt'];
txtpath = alterPath( txtpath );
fid = fopen(txtpath, 'r');
if fid==-1
    errorlog('打开文件',txtpath,'失败！');
end
cmd = fgetl(fid); % 从第一行读取svr参数
fclose(fid);




