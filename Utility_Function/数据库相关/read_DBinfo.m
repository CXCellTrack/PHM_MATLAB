function linkDB = read_DBinfo( configFileAddr )

% �˺������ڴ����ݿ������ļ��ж��������������ֵ

% ----- ���ݿ����Ӳ��� ----- %
% linkDB.database_url_mysql = '';
% linkDB.driver_mysql = '';
% linkDB.username_mysql = '';
% linkDB.password_mysql = '';

linkDB.database_url_oracle = '';
linkDB.driver_oracle = '';
linkDB.username_oracle = '';
linkDB.password_oracle = '';
linkDB.service_name_oracle = '';

% ----- ��񴴽����������ã� ----- %

% ------------------- %

% ������struct����cell��
structCell{1} = linkDB;

% ����ͨ�ú��� GetConfigInfo ��ȡ�����ļ�
structCell = GetConfigInfo( configFileAddr, structCell,  'str' );

% ��ֵ������ȥ
linkDB = structCell{1};




















