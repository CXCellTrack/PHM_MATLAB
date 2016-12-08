function linkDB = read_DBinfo()


%% 2016.12.8将配置文件.ini统一修改为conf格式
PHM_HOME = getphmpath('home');
DBinfoAddr = [PHM_HOME, '\DBinfo.ini'];
if ~exist(DBinfoAddr, 'file')
    errorlog(['打开配置文件', alterPath(DBinfoAddr), '失败！']);
end

linkDB = read_conf(DBinfoAddr);


%% 原读取方法
% % 此函数用于从数据库配置文件中读入各参数的配置值
% 
% % ----- 数据库连接参数 ----- %
% % linkDB.database_url_mysql = '';
% % linkDB.driver_mysql = '';
% % linkDB.username_mysql = '';
% % linkDB.password_mysql = '';
% 
% linkDB.database_url_oracle = '';
% linkDB.driver_oracle = '';
% linkDB.username_oracle = '';
% linkDB.password_oracle = '';
% linkDB.service_name_oracle = '';
% 
% % ----- 表格创建参数（备用） ----- %
% 
% % ------------------- %
% 
% % 将所有struct放入cell中
% structCell{1} = linkDB;
% 
% % 调用通用函数 GetConfigInfo 读取配置文件
% structCell = GetConfigInfo( configFileAddr, structCell,  'str' );
% 
% % 将值解析出去
% linkDB = structCell{1};




















