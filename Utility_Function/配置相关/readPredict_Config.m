function [ n_train n_predict diag_trigger_time ] = readPredict_Config()
% 内部函数：用于读入预测设置信息
predictpath = getphmpath('predict');
inipath = [predictpath, '\predict_config.ini'];
inipath = alterPath( inipath );

if ~exist(inipath, 'file')
    errorlog(['打开配置文件', alterPath(inipath), '失败！']);
end

conf = read_conf(inipath);
n_train = str2double(conf.n_train);
n_predict = str2double(conf.n_predict);
diag_trigger_time = str2double(conf.diag_trigger_time);



% str = mydeblank(fgetl(fid)); % 从第一行读取参数
% fclose(fid);
% info = strsplit(' ', str);
% 
% for i=1:2:numel(info)
%     switch info{i}
%         case 'n_train'
%             n_train = str2num(info{i+1});
%             if mod(n_train,1) || n_train<=0
%                 errorlog('训练样本必须为正整数！');
%             end
%         case 'n_predict'
%             n_predict = str2num(info{i+1});
%             if mod(n_predict,1) || n_predict<=0
%                 errorlog('预测次数必须为正整数！');
%             end
%         case 'diag_trigger_time'
%             diag_trigger_time = str2num(info{i+1});
%             if mod(diag_trigger_time,1) || diag_trigger_time<=0
%                 errorlog('触发时限必须为正整数！');
%             end
%     end
% end
