
pwd
home = pwd;
subpath = genpath(home);
% ����strsplit��Ҫ�õ�BNT�������е�KPMtools
subpath = strsplit(';', subpath(1:end-1)); % ȥ��ĩβ�Ŀո�

newpath = [];
ignore_path = {'Csharp����', '.git', 'MCR files', 'Precompiled EXE',...
    'Release_Version', '���ʹ���ĵ�', '���д�����sql�ű�'};

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

if newpath(1) == ';' % ȥ����ͷ���ܴ��ڵĿո�
    newpath(1) = '';
end

addpath(newpath);
savepath;
disp([home, ' ·����ӳɹ�']);
