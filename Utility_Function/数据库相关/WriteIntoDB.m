function WriteIntoDB( conn, data2write, tablename )
% ��data2write���cellд�뵽conn�����ݿ��tablename�����
% �˺�������Ϊͨ�ú���
% �����е��õ� insert...������Ҫ���ÿ�ֹ���ÿ�ֱ��

% ��֤����Ƿ����
validateTable(conn, tablename);
writelog(['�����д��oracle���ݿ��',tablename,'��...\n']);
writelog(['<��',num2str(size(data2write,1)),'������>\n']);

tic;
switch tablename
    % -------------------- ��ϲ��ֱ�� ------------------- %
    case 'YJ_WARNING_DIAGNOSIS'
        insert_DR( conn, data2write, tablename );
        
    % -------------------- �������������ֱ�� ------------------- %
    case 'YJ_WARNING_HEALTH'
        insert_HE( conn, data2write, tablename );
        
    % -------------------- ����Ԥ�����ֱ�� ------------------- %
    case 'predict_result_water'
        insert_PR( conn, data2write, tablename );
        
end

writelog('toc', toc);
writelog('����д��ɹ���\n\n==========================================\n',1);


