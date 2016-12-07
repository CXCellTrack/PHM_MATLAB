
pwd
home = pwd;
subpath = genpath(home);
% 函数strsplit需要用到BNT工具箱中的KPMtools
subpath = strsplit(';', subpath(1:end-1)); % 去掉末尾的空格

newpath = [];
ignore_path = {'Csharp代码', '.git', 'MCR files', 'Precompiled EXE',...
    'Release_Version', '软件使用文档', '序列触发器sql脚本'};

for i=1:numel(subpath)
    add_flag = true;
    for ip=ignore_path
        if ~isempty(strfind(subpath{i}, ip{1}))
            add_flag = false;
            break;
        end
    end
    if add_flag
        newpath = [ newpath, ';', subpath{i} ];
    end
end

if newpath(1) == ';' % 去掉开头可能存在的空格
    newpath(1) = '';
end

addpath(newpath);
savepath;
disp([home, ' 路径添加成功']);
