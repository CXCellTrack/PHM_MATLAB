function execute_sql_script(script_path)

global DB
% ��ȡ���ݿ���Ϣ
user = DB.username_oracle;
pw = DB.password_oracle;
sid = DB.service_name_oracle;
url = DB.database_url_oracle;
remote_ip = url(strfind(url, '@')+1:end-1);
remote_sid = [remote_ip, '/', sid];

exesql = sprintf('sqlplus %s/%s@%s @%s', user, pw, remote_sid, script_path);
system( exesql );