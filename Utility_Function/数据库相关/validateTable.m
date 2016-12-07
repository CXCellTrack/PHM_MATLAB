function validateTable( conn, tablename )
%
% 检查数据库owner中是否存在表格tablename
% 

s1 = fetch(exec(conn, ['select table_name from all_tables where owner = ''', upper(conn.UserName),'''']));
if ~isempty(s1.Message)
    errorlog(s1.Message);
end
close(s1);

cmpflag = strncmpi( tablename, s1.Data, 50 );
close(s1);
if any(cmpflag==1)
    writelog(['目标表格',tablename,'校验成功！\n'],1);
else
    errorlog(['数据库',conn.Instance,'中不存在表格',tablename,', 请先创建表格']);
%     if 0
%         % 通过命令行执行sql脚本
%         exesql = ['sqlplus ',owner,'/',pw,'@',dbname,' @', SQL.create_diag_result_Water];
%         system( exesql );
%     end

end



