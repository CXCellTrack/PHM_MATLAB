function [ MAX MIN ] = getMaxMinInDBCol( conn, colname, tablename )
%
% ����һ������ĳ���е����ֵ
% input��
%       conn������
%       colname������
%       tablename������
%
sql = ['select max("', colname ,'"),min("', colname ,'")  from "', tablename,'"'];
Data = fetch_data(conn, sql);

MAX = Data{1};
MIN = Data{2};



end

