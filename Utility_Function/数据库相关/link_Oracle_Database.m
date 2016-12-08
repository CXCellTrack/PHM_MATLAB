function conn = link_Oracle_Database

% �˺���ʹ��linkDB�е��û������������Ϣ����oracle���ݿ�
% ������֤tablename�Ƿ���������ݿ���
% ������ڣ�������
% ��������ڣ������SQL�е���Ϣ�����ñ�񣨵�����ǰд�õ�sql�ļ���
% ----------------------------------------------------------------------- %
writelog('����ORACLE���ݿ�...\n\n');
global DB
DB = read_DBinfo();
dbname = DB.service_name_oracle;
% ����oracle���ݿ�
conn = database( dbname, DB.username_oracle, DB.password_oracle, ...
    DB.driver_oracle, DB.database_url_oracle);
% ʹ��set�޸�conn����Ϣ
% set(conn, 'AutoCommit', 'off'); % ��Ϊoff����Ҫ��ִ�к� commit(conn) ������Ч
% ��������ʱconn.MessageΪ�գ�����Ϊ��������Ϣ���

if isconnection(conn)
    writelog(['�ɹ����ӵ�ORACLE-', dbname, '���ݿ⣡\n\n**************************\n\n'], 1);
else
    writelog(conn.Message);
end



