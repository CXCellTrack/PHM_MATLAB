function ImportTxt2DB( tablename, pipeclass )
% 
% 这个函数用于校验txt的正确性（通过recordId）
% 并且将txt中的内容写入到数据库
% input：
%   conn——连接
%   txtname——txt文件地址
%   tablename——目标表格名称
%   validinfo——校验信息，初步选用记录编号
%   recordId_ind——记录编号在表格中的列号
%
% ouput：
%   无

%------------------------------------------------------------------------ %
%-------- 使用recordID检查txt中的内容是否确实为刚才一次诊断生成的 ---------- %
%------------------------------------------------------------------------ %
if 0
    error_num = 0;
    while 1
        fid = fopen( txtname, 'r');
        if fid==-1
            errorlog(['打开',txtname,'失败！']);
        end
        line1 = fgetl(fid);
        fclose(fid);
        strCell = splitStrIntoCell( line1, ',' );
        if strcmp(strCell{validinfo_ind}, num2str(validinfo))
            writelog(['记录编号为',num2str(validinfo),',校验无误\n']);
            break;
        else
            error_num = error_num + 1;
            if error_num==20
                errorlog('记录编号校验失败！\n');
            end
            writelog(['记录编号校验出错,0.5秒后再次将进行校验...当前第',error_num,'次\n']);
            pause(0.5);
        end
    end
end % 数据校验暂时不启用了
    
%------------------------------------------------------------------------ %
%---------------------- 将txt中的内容写入数据库 -------------------------- %
%------------------------------------------------------------------------ %

predictpath = getphmpath('predict');
controlpath = [predictpath, '\txt2db.ctl'];

% 修改ctl要发送的文件名
lines = textread(controlpath, '%s','delimiter','\n');
lines{3} = ['"%predictpath%\',pipeclass,'\data\backup_',pipeclass,'.txt"'];
fid = fopen(controlpath, 'w');
for ii=1:numel(lines)
    fprintf(fid, '%s\r\n', lines{ii});
end
fclose(fid);

global DB
% 读取数据库信息
user = DB.username_oracle;
pw = DB.password_oracle;
sid = DB.service_name_oracle;
url = DB.database_url_oracle;
remote_ip = url(strfind(url, '@')+1:end-1);
remote_sid = [remote_ip, '/', sid];

fprintf('从txt导入到数据库表格%s...\n', tablename);
tic;
try
    % oracle的方式需要通过命令行执行control脚本，无法直接通过sql语句导入
    exesql = ['sqlldr ',user,'/',pw,'@',remote_sid,' control=',controlpath,' log=',...
        controlpath(1:end-3), 'log', ' bindsize=',num2str(10*2^20),' rows=4096 silent=header'];
    % rows默认为64，且受到bindsize的限制；因此将bindsize设为10M，rows可设为4096，以加快读入速度；不输出头部信息
    system( exesql );
catch
    errorlog(['通过sqlldr执行控制脚本', alterPath(controlpath), '失败！请查看log日志']);
end
writelog('toc', toc);
writelog('数据导入完成！\n\n==========================================\n',true);



% ----------------------------------------------------------------------- %
% 原mysql方式，可以直接通过sql语句导入
% 将txt导入sql，速度快。用insert将数据写入数据库中要费时10秒左右
% txtname = strrep(txtname, '\', '/'); % 文件名要为'/'或者'\\'才行
% if 0 
%     inSql = ['load data local infile ''', txtname, ''' into table ', tablename,...
%         ' fields terminated by '','' lines terminated by ''\n'' '];
%     s1 = exec(conn, inSql);
%     if ~isempty(s1.Message)
%         error(s1.Message);
%     end
%     close(s1);
% end
% ----------------------------------------------------------------------- %






