function writelog( event, addtime, mode )
% 
% 本函数用来将exe的运行结果写入log中
% 便于在windows服务中进行错误处理
% 
% addtime为0或1：用来指示是否加上时间
% ----------------------------------------------------------------------- %

% 这是一类特殊用法，event填写'toc'，addtime填写toc，输出代码时间(tic,toc)
% 示例：writelog('toc',toc);
if nargin==2 && strcmp(event,'toc')==1  
    writelog(['<耗时> ',num2str(addtime),'秒\n']); % 函数调用自身
    return;
end

% ----------------------------------------------------------------------- %
if nargin==1
    addtime = 0;
    mode = 'append';
elseif nargin==2 % mode不指定的话默认为1
    mode = 'append';
end
switch mode
    case 'rewrite'
        mode = 'wt';
    case 'append'
        mode = 'at';
    otherwise
        error('日志文件操作模式只能为 rewrite 或 append');
end

home = getphmpath('home');
fid = fopen([home, '\Csharp代码\PHM.log'], mode);
if fid==-1
    error('打开log文件失败！');
end

% ----------------------------------------------------------------------- %
% 当前时间整理为字符串格式
% nowtime = [num2str(year(now)),'/',num2str(month(now)),'/',num2str(day(now)),...
%     ' ',num2str(hour(now)),':',num2str(minute(now)),':',num2str(fix(second(now)))];
nowtime = datestr(now,31);
% 使用addtime来指示是否加上时间戳
if addtime
    event = ['<时间> ',nowtime,'\n', event];
end
fprintf(fid, event); % 将信息写入log中
fclose(fid);

% ----------------------------------------------------------------------- %
% 在控制台打印下，方便matlab调试
fprintf(event);


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
