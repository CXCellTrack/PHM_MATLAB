function validateTable( conn, tablename )
%
% ������ݿ�owner���Ƿ���ڱ��tablename
% 

s1 = fetch(exec(conn, ['select table_name from all_tables where owner = ''', upper(conn.UserName),'''']));
if ~isempty(s1.Message)
    errorlog(s1.Message);
end
close(s1);

cmpflag = strncmpi( tablename, s1.Data, 50 );
close(s1);
if any(cmpflag==1)
    writelog(['Ŀ����',tablename,'У��ɹ���\n'],1);
else
    errorlog(['���ݿ�',conn.Instance,'�в����ڱ��',tablename,', ���ȴ������']);
%     if 0
%         % ͨ��������ִ��sql�ű�
%         exesql = ['sqlplus ',owner,'/',pw,'@',dbname,' @', SQL.create_diag_result_Water];
%         system( exesql );
%     end

end



