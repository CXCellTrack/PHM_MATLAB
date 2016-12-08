function insert_DR( conn, data2write, tablename)

squence_name = 'SEQ_YJ_WARNING_DIAGNOSIS';

% ��Ϊ����ȫ���ַ��������Ҫ�õ�����������
cf = ','; % ������
df = ''''; % ��������

for i=1:size(data2write,1)
    % values()�����е�����
    thisdata = ...
    [ 
        [squence_name,'.nextval'], cf,...
        [df,data2write{i,1},df], cf,...
        [df,data2write{i,2},df], cf,...
        [df,data2write{i,3},df], cf,...
        [df,data2write{i,5},df], cf,...
        ['to_timestamp(',[df,data2write{i,4},df],cf,[df,'yyyy-mm-dd hh24:mi:ss',df],')'] 
    ];

    % ע��sql����д����fieldname����"",values�е��ַ�������''
    sql = ['insert into "',tablename,'" ("DBID","PIPEID","FAULTTYPE","PROBABLITY","RECORDID","CHECKTIME")',...
        ' values(',thisdata,')'];
    
    fetch_data(conn, sql);
end

