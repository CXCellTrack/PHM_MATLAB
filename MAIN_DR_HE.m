function MAIN_DR_HE
%
% ������Ϻͽ�������������
% ����һ��ͨ�ú��������������еĹ������ͣ���ȫ��д�����ݿ�
% ���������windows�����ж�Ϊ1Сʱִ��һ��
% -------------------------------------------
writelog('����PHM���ϵͳ...\n', true, 'rewrite');
% 1������oracle���ݿ�
conn = link_Oracle_Database;
% 2����ϲ�д�����ݿ�
DiagMain( conn );
% 3��������������д�����ݿ�
EvalMain( conn );
% end���ر����ݿ�����
close(conn);
writelog('���ݿ����ӹرգ�\n', 1);

% ��������ļ�
fid = fopen([getphmpath('home'), '\Csharp����\done.flag'], 'w+');
fclose(fid);

% �������ݿ��ȡ��ʽ
% setdbprefs('datareturnformat', 'cellarray')
% setdbprefs('datareturnformat', 'numeric')













