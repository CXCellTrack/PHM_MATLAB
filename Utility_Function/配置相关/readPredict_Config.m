function [ n_train n_predict diag_trigger_time ] = readPredict_Config()
% �ڲ����������ڶ���Ԥ��������Ϣ
predictpath = getphmpath('predict');
inipath = [predictpath, '\predict_config.ini'];
inipath = alterPath( inipath );

if ~exist(inipath, 'file')
    errorlog(['�������ļ�', alterPath(inipath), 'ʧ�ܣ�']);
end

conf = read_conf(inipath);
n_train = str2double(conf.n_train);
n_predict = str2double(conf.n_predict);
diag_trigger_time = str2double(conf.diag_trigger_time);



% str = mydeblank(fgetl(fid)); % �ӵ�һ�ж�ȡ����
% fclose(fid);
% info = strsplit(' ', str);
% 
% for i=1:2:numel(info)
%     switch info{i}
%         case 'n_train'
%             n_train = str2num(info{i+1});
%             if mod(n_train,1) || n_train<=0
%                 errorlog('ѵ����������Ϊ��������');
%             end
%         case 'n_predict'
%             n_predict = str2num(info{i+1});
%             if mod(n_predict,1) || n_predict<=0
%                 errorlog('Ԥ���������Ϊ��������');
%             end
%         case 'diag_trigger_time'
%             diag_trigger_time = str2num(info{i+1});
%             if mod(diag_trigger_time,1) || diag_trigger_time<=0
%                 errorlog('����ʱ�ޱ���Ϊ��������');
%             end
%     end
% end
