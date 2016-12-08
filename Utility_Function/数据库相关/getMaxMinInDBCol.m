function [ MAX MIN ] = getMaxMinInDBCol( conn, colname, tablename )
%
% 返回一个表中某个列的最大值
% input：
%       conn：连接
%       colname：列名
%       tablename：表名
%
sql = ['select max("', colname ,'"),min("', colname ,'")  from "', tablename,'"'];
Data = fetch_data(conn, sql);

MAX = Data{1};
MIN = Data{2};



end

