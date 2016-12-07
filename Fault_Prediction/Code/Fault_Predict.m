function data2write = Fault_Predict( conn, pipeclass )

predict_path = getphmpath('predict');
eval_path = getphmpath('eval');

% 读入 data2write_Water.mat，提取其中的 s_fault 和 faultclass 信息
diagpath = getphmpath('diag');
load([diagpath, '\',pipeclass,'\data\mat\data2write_',pipeclass,'.mat']);
for i=1:size(data2write,1)
    if ~strcmp(data2write(i+1,1), data2write(i,1))
        break
    end
end
s_fault = i;
faultclass = data2write(1:i,2);
clear data2write % 提取完信息之后删去 data2write


% 选择管线进行预测
diagtablename = 'YJ_WARNING_DIAGNOSIS';

% 原本打算用SVR做预测，后来使用线性外推，这个就不需要了
% cmd = readSVRparam( predict_path, 'Water');
% ------------------------------------------ %
txtname = [predict_path,'\',pipeclass,'\data\backup_',pipeclass,'.txt'];
% 载入 eval_data2write_ 是为了获取 n_pipe 和 管线名称
load([eval_path, '\',pipeclass,'\data\mat\eval_data2write_',pipeclass,'.mat']);

%% 下面这部分是进行预测的通用函数
% --------------------------------------------------------------
% n_train 限制训练样本的个数
% n_predict 预测未来多少次的输出
[ n_train n_predict diag_trigger_time ] = readPredict_Config();
n_pipe = size(eval_data2write,1);
[last_dr_id, ~] = getMaxMinInDBCol( conn, 'RECORDID', diagtablename ); % 最近一次诊断结果的id（string类型！）
% setdbprefs('datareturnformat', 'numeric'); % 设置导入的数据为矩阵类型
data = zeros(n_pipe*s_fault, n_predict); % 数据
bias = zeros(n_pipe*s_fault, n_predict); % 偏差

writelog(['<预测',num2str(n_pipe),'个管线未来',num2str(n_predict),'小时的故障发生概率>\n']);
tic
for i=1:n_pipe
    thispipe = eval_data2write{i,1};
%     fprintf('开始预测管线%d...\n',i);
    for j=1:s_fault

        sql = ['SELECT "PROBABLITY" FROM (SELECT * FROM "',diagtablename,'" ORDER BY "RECORDID" DESC) WHERE "PIPEID"=''',...
            thispipe,''' AND "FAULTTYPE"=''',faultclass{j},...
            ''' AND ROWNUM<= ',num2str(n_train),' AND "RECORDID"<=''',last_dr_id,''''];
        
        DATA = fetch_data(conn,sql);
        if strcmp(DATA, 'No Data')
            errorlog(['数据库表格',diagtablename,'中无数据！预测无法进行！']);
        else
            DATA = str2double(DATA); % 转为mat格式
            if numel(DATA)<4
                errorlog(['诊断表格',diagtablename,'中历史数据过少！预测无法进行！']);
            end
        end
        
        train_data = fliplr(DATA');
        train_fea = 1:size(train_data,2);
        test_fea = (train_fea(end)+1: train_fea(end)+n_predict);
        % 调用自写函数进行SVR预测，SVR参数在cmd中
    %     [ prediction bias ] = SVRpredict( train_data, train_fea, test_fea, cmd );
        [ prediction delta ] = LinerPredict( train_data, train_fea, test_fea );

%         if 0
%             plot(train_fea, train_data, 'b.');hold on;
%             plot(test_fea,prediction,'r',test_fea,prediction+bias,'g',test_fea, prediction-bias,'g');hold off;
%         end
        
        data(s_fault*(i-1)+j,:) = prediction; % 每一行是一个故障的预测结果
        bias(s_fault*(i-1)+j,:) = delta; % 每一行是一个故障的预测偏差
        
    end
end
writelog(['<使用了',num2str(size(train_data,2)),'条历史数据>\n']);
toc
writelog('故障预测完成！\n\n', 1);

% --------------------------------------------------------------
% 将data整合成data2write——字符串cell形式
data2write = get_PR_data( eval_data2write(:,1), data, bias, last_dr_id, n_pipe, faultclass, diag_trigger_time );

% 数据本地备份
WriteData2txt( txtname, data2write );











