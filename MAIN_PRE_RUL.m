function MAIN_PRE_RUL
%
% ����Ԥ���ʣ������Ԥ�ⲿ��
% ����һ��ͨ�ú��������������еĹ������ͣ���ȫ��д�����ݿ�
% ���������windows�����ж�Ϊ1��ִ��һ��
% -------------------------------------------
writelog('����PHM���ϵͳ...\n\n', true, 'rewrite');
% 1������oracle���ݿ�
conn = link_Oracle_Database;
% 2�����й���Ԥ��
PredictMain( conn );
% 3������ʣ������Ԥ��
% RULMain( conn );
% end���ر����ݿ�����
close(conn);
writelog('���ݿ����ӹرգ�\n',1);

% ��������ļ�
fid = fopen([getphmpath('home'), '\Csharp����\done.flag'], 'w+');
fclose(fid);