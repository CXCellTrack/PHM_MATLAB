function ImportTxt2DB( tablename, pipeclass )
% 
% �����������У��txt����ȷ�ԣ�ͨ��recordId��
% ���ҽ�txt�е�����д�뵽���ݿ�
% input��
%   conn��������
%   txtname����txt�ļ���ַ
%   tablename����Ŀ��������
%   validinfo����У����Ϣ������ѡ�ü�¼���
%   recordId_ind������¼����ڱ���е��к�
%
% ouput��
%   ��

%------------------------------------------------------------------------ %
%-------- ʹ��recordID���txt�е������Ƿ�ȷʵΪ�ղ�һ��������ɵ� ---------- %
%------------------------------------------------------------------------ %
if 0
    error_num = 0;
    while 1
        fid = fopen( txtname, 'r');
        if fid==-1
            errorlog(['��',txtname,'ʧ�ܣ�']);
        end
        line1 = fgetl(fid);
        fclose(fid);
        strCell = splitStrIntoCell( line1, ',' );
        if strcmp(strCell{validinfo_ind}, num2str(validinfo))
            writelog(['��¼���Ϊ',num2str(validinfo),',У������\n']);
            break;
        else
            error_num = error_num + 1;
            if error_num==20
                errorlog('��¼���У��ʧ�ܣ�\n');
            end
            writelog(['��¼���У�����,0.5����ٴν�����У��...��ǰ��',error_num,'��\n']);
            pause(0.5);
        end
    end
end % ����У����ʱ��������
    
%------------------------------------------------------------------------ %
%---------------------- ��txt�е�����д�����ݿ� -------------------------- %
%------------------------------------------------------------------------ %

predictpath = getphmpath('predict');
controlpath = [predictpath, '\txt2db.ctl'];

% �޸�ctlҪ���͵��ļ���
lines = textread(controlpath, '%s','delimiter','\n');
lines{3} = ['"%predictpath%\',pipeclass,'\data\backup_',pipeclass,'.txt"'];
fid = fopen(controlpath, 'w');
for ii=1:numel(lines)
    fprintf(fid, '%s\r\n', lines{ii});
end
fclose(fid);

global DB
% ��ȡ���ݿ���Ϣ
user = DB.username_oracle;
pw = DB.password_oracle;
sid = DB.service_name_oracle;
url = DB.database_url_oracle;
remote_ip = url(strfind(url, '@')+1:end-1);
remote_sid = [remote_ip, '/', sid];

fprintf('��txt���뵽���ݿ���%s...\n', tablename);
tic;
try
    % oracle�ķ�ʽ��Ҫͨ��������ִ��control�ű����޷�ֱ��ͨ��sql��䵼��
    exesql = ['sqlldr ',user,'/',pw,'@',remote_sid,' control=',controlpath,' log=',...
        controlpath(1:end-3), 'log', ' bindsize=',num2str(10*2^20),' rows=4096 silent=header'];
    % rowsĬ��Ϊ64�����ܵ�bindsize�����ƣ���˽�bindsize��Ϊ10M��rows����Ϊ4096���Լӿ�����ٶȣ������ͷ����Ϣ
    system( exesql );
catch
    errorlog(['ͨ��sqlldrִ�п��ƽű�', alterPath(controlpath), 'ʧ�ܣ���鿴log��־']);
end
writelog('toc', toc);
writelog('���ݵ�����ɣ�\n\n==========================================\n',true);



% ----------------------------------------------------------------------- %
% ԭmysql��ʽ������ֱ��ͨ��sql��䵼��
% ��txt����sql���ٶȿ졣��insert������д�����ݿ���Ҫ��ʱ10������
% txtname = strrep(txtname, '\', '/'); % �ļ���ҪΪ'/'����'\\'����
% if 0 
%     inSql = ['load data local infile ''', txtname, ''' into table ', tablename,...
%         ' fields terminated by '','' lines terminated by ''\n'' '];
%     s1 = exec(conn, inSql);
%     if ~isempty(s1.Message)
%         error(s1.Message);
%     end
%     close(s1);
% end
% ----------------------------------------------------------------------- %






