function DATA = fetch_data(conn, sql)

gett = exec(conn, sql);
if ~isempty(gett.Message)
    errorlog(gett.Message);
end
gett = fetch(gett);
DATA = gett.Data;
close(gett); % 要及时关闭游标，否则会达到最大数报错