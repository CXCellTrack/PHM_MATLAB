function insert_PR( conn, data2write, tablename )


for i=1:size(data2write,1)
    % values()�����е�����
    % ���������˴�����������Ҫ��'seq_PRwater.nextval'д�ڵ�һ����
    thisdata = [ data2write{i,1}, ',''', data2write{i,2}, ''',', data2write{i,3},...
        ',',data2write{i,4},',to_date(''', data2write{i,5}, ''',''yyyy-mm-dd hh24:mi:ss''), ''',data2write{i,6},''',''', data2write{i,7},''''];
    % ע��sql����д����fieldname����"",values�е��ַ�������''
    sql = ['insert into "',tablename,...
        '" ("db_id","pipe_id","fault_type","predict_prob","prob_bias","predict_time","analysis","pre_record_id")',...
        ' values(',thisdata,')'];
    
    fetch_data(conn, sql);
end
