function conn = link_Oracle_Database

% �˺���ʹ��linkDB�е��û������������Ϣ����oracle���ݿ�
% ������֤tablename�Ƿ���������ݿ���
% ������ڣ�������
% ��������ڣ������SQL�е���Ϣ�����ñ�񣨵�����ǰд�õ�sql�ļ���
% ----------------------------------------------------------------------- %
writelog('����ORACLE���ݿ�...\n\n');

PHM_HOME = getphmpath('home');
DBinfoAddr = [PHM_HOME, '\DBinfo.ini'];
linkDB = read_DBinfo( DBinfoAddr );

dbname = linkDB.service_name_oracle;
user = linkDB.username_oracle;
pw = linkDB.password_oracle;
% ����oracle���ݿ�
conn = database( dbname, user, pw, linkDB.driver_oracle, linkDB.database_url_oracle);
% ʹ��set�޸�conn����Ϣ
% set(conn, 'AutoCommit', 'off'); % ��Ϊoff����Ҫ��ִ�к� commit(conn) ������Ч
% ��������ʱconn.MessageΪ�գ�����Ϊ��������Ϣ���

if isconnection(conn)
    writelog(['�ɹ����ӵ�ORACLE-', dbname,'���ݿ⣡\n\n**************************\n\n'], 1);
else
    writelog(conn.Message);
end



