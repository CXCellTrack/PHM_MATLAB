function Val_Pre_Result()

% ����Ͻ��д��Ԥ����Դ�����֤Ԥ�����Ƿ�׼ȷ
% ����ȫ��sqlplus�Ͻ��У�ʹ�ýű�
% �����������-->Ԥ��������㾫��
% ѡ����߽���Ԥ��
predict_path = getphmpath('predict');

sqladdr = [predict_path,'\update_PR.sql'];

% ִ��sql�ű�����Ԥ���е������֤����
try
	execute_sql_script(sqladdr);
catch
    errorlog(['ʹ��sqlplusִ��sql�ű�', alterPath(sqladdr), 'ʧ�ܣ�']);
end
    
    
    
    
    
    

