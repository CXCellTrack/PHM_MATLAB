function run_post_sqls(module_name)

% ��������ļ���֪ͨ������PHM.log
fid = fopen([getphmpath('home'), '\Csharp����\done.flag'], 'w+');
fclose(fid);

sql_path = [getphmpath(module_name), '\SQL\sqls_to_run.sql'];
execute_sql_script(sql_path);
        

