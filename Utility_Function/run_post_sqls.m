function run_post_sqls(module_name)

% 创建标记文件，通知服务检查PHM.log
fid = fopen([getphmpath('home'), '\Csharp代码\done.flag'], 'w+');
fclose(fid);

sql_path = [getphmpath(module_name), '\SQL\sqls_to_run.sql'];
execute_sql_script(sql_path);
        

