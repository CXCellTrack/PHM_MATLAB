function structCell = GetConfigInfo( configFilePath, structCell,  num_or_str )
%
% input:
%   configFilePath: 配置文件的地址
%   structCell:     是一个cell，每个cell中都是结构体，用于存储变量值
%                   注意结构体的fieldnames必须和配置文件中的一样！
%   HOME：          如果在配置文件中使用了相对路径，如home=D：,{home}\1.txt就表示D：\1.txt
% outout：
%   structCell:     读入配置文件后的结构体cell
% -------------------------------------------------------------------------
narginchk(3,3);
if ~strcmp(num_or_str, 'num') && ~strcmp(num_or_str, 'str')
    errorlog('第3个输入变量必须为''num''或者''str''中的一个！');
end

% 打开配置文件
configFilePath = alterPath( configFilePath );
fidin = fopen( configFilePath, 'r'); 
if fidin==-1
    errorlog(['打开配置文件',configFilePath,'失败！']);
end

while ~feof(fidin) % 判断是否为文件末尾   
    % 从文件读行并去掉行尾的空格
    tline = mydeblank(fgetl(fidin));
    if numel(tline)==0 || strcmp(tline(1), '#') % 行首为#，说明是注释，则跳过
        continue;
    end
    % 找到等号的位置
    strcell = strsplit('=', tline);
    % -------------------------------------- %
    % 读入structCell中各个结构体内的地址
    for i=1:numel(structCell)
        [ structCell{i} flag ] = AutoSetField( structCell{i}, strcell, num_or_str );
        if flag
            break;
        end
    end

end
fclose(fidin);




% 内部函数：AutoSetField
function [ A flag ] = AutoSetField( A, strcell, num_or_str )

% 这个函数用于从config文件中读取不同变量的赋值
% 并对应到struct A的各个field上
% 注意：需要提前设定好A的各个field名称，并赋给A_names
% num_or_str只能是'num'或者'str'，控制输出域内值类型


A_names = fieldnames(A);
flag = 0; % 退出标识符，为1说明找到field，进入下一行
for i=1:numel(A_names)
    if strncmp(A_names{i}, strcell{1}, numel(A_names{i}))
        
        value = mydeblank(strcell{2}); % 截取等号后面的部分
        if strcmp(num_or_str, 'num')
            value = str2num(value);
        end
        A = setfield(A, A_names{i}, value);
        flag = 1;
        break;
    end
end







