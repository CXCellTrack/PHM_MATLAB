function [ MAX MIN ] = getMaxMinInDBCol( conn, colname, tablename )
%
% ����һ������ĳ���е����ֵ
% input��
%       conn������
%       colname������
%       tablename������
%
getMaxMin = fetch(exec(conn, ['select max("', colname ,'"),min("', colname ,'")  from "', tablename,'"']));
close( getMaxMin );

if ~isempty(getMaxMin.Message)
    errorlog(getMaxMin.Message);
end

Data = getMaxMin.Data;

MAX = Data{1};
MIN = Data{2};



end

