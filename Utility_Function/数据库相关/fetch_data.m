function DATA = fetch_data(conn, sql)

gett = exec(conn, sql);
if ~isempty(gett.Message)
    errorlog(gett.Message);
end
gett = fetch(gett);
DATA = gett.Data;
close(gett); % Ҫ��ʱ�ر��α꣬�����ﵽ���������