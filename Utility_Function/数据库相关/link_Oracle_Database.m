function conn = link_Oracle_Database

% 此函数使用linkDB中的用户名、密码等信息连接oracle数据库
% 并且验证tablename是否存在于数据库中
% 如果存在，则正常
% 如果不存在，则调用SQL中的信息创建该表格（调用提前写好的sql文件）
% ----------------------------------------------------------------------- %
writelog('连接ORACLE数据库...\n\n');

PHM_HOME = getphmpath('home');
DBinfoAddr = [PHM_HOME, '\DBinfo.ini'];
linkDB = read_DBinfo( DBinfoAddr );

dbname = linkDB.service_name_oracle;
user = linkDB.username_oracle;
pw = linkDB.password_oracle;
% 连接oracle数据库
conn = database( dbname, user, pw, linkDB.driver_oracle, linkDB.database_url_oracle);
% 使用set修改conn的信息
% set(conn, 'AutoCommit', 'off'); % 设为off后需要在执行后 commit(conn) 才能生效
% 连接正常时conn.Message为空，若不为空则将其信息输出

if isconnection(conn)
    writelog(['成功连接到ORACLE-', dbname,'数据库！\n\n**************************\n\n'], 1);
else
    writelog(conn.Message);
end



