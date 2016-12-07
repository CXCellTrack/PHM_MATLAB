function insert_HE( conn, data2write, tablename)

squence_name = 'SEQ_YJ_WARNING_HEALTH';

% 因为几乎全是字符串，因此要用单引号引起来
cf = ','; % 代表逗号
df = ''''; % 代表单引号

for i=1:size(data2write,1)
    % values()括号中的内容
    thisdata = ...
    [ 
        [squence_name,'.nextval'], cf,...
        [df,data2write{i,1},df], cf,...
        [df,data2write{i,2},df], cf,...
        [df,data2write{i,3},df], cf,...
        [df,data2write{i,5},df], cf,...
        ['to_timestamp(',[df,data2write{i,4},df],cf,[df,'yyyy-mm-dd hh24:mi:ss',df],')'] 
    ];

    % 注意sql语句的写法，fieldname得用"",values中的字符串得用''
    sql = ['insert into "',tablename,'" ("DBID","PIPEID","MEMO","RANK","EVALRECORDID","EVALTIME")',...
        ' values(',thisdata,')'];
    send = exec(conn, sql);
    if ~isempty(send.Message)
        errorlog(send.Message);
    end
    close(send); % 要及时关闭游标，否则会达到最大数报错
end
