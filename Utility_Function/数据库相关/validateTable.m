function validateTable( conn, tablename )
%
% ������ݿ�owner���Ƿ���ڱ��tablename
% 

tbs = fetch_data(conn, ['select table_name from all_tables where owner = ''', upper(conn.UserName),'''']);
cmpflag = strncmpi( tablename, tbs, 50 );
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



