function Val_Pre_Result( DB )

% ����Ͻ��д��Ԥ����Դ�����֤Ԥ�����Ƿ�׼ȷ
% ����ȫ��sqlplus�Ͻ��У�ʹ�ýű�
% �����������-->Ԥ��������㾫��
% ѡ����߽���Ԥ��
predict_path = getphmpath('predict');

sqladdr = [predict_path,'\update_PR.sql'];

% ��ȡ���ݿ���Ϣ
user = DB.username_oracle;
pw = DB.password_oracle;
sid = DB.service_name_oracle;

% ִ��sql�ű�����Ԥ���е������֤����
try
    sql = ['sqlplus ',user,'/',pw,'@',sid,' @',sqladdr];
    system(sql);
catch
    sqladdr = alterPath( sqladdr );
    errorlog('ʹ��sqlplusִ��sql�ű�',sqladdr,'ʧ�ܣ�');
end
    
    
    
    
    
    

