function data2write = Fault_Predict( conn, pipeclass )

predict_path = getphmpath('predict');
eval_path = getphmpath('eval');

% ���� data2write_Water.mat����ȡ���е� s_fault �� faultclass ��Ϣ
diagpath = getphmpath('diag');
load([diagpath, '\',pipeclass,'\data\mat\data2write_',pipeclass,'.mat']);
for i=1:size(data2write,1)
    if ~strcmp(data2write(i+1,1), data2write(i,1))
        break
    end
end
s_fault = i;
faultclass = data2write(1:i,2);
clear data2write % ��ȡ����Ϣ֮��ɾȥ data2write


% ѡ����߽���Ԥ��
diagtablename = 'YJ_WARNING_DIAGNOSIS';

% ԭ��������SVR��Ԥ�⣬����ʹ���������ƣ�����Ͳ���Ҫ��
% cmd = readSVRparam( predict_path, 'Water');
% ------------------------------------------ %
txtname = [predict_path,'\',pipeclass,'\data\backup_',pipeclass,'.txt'];
% ���� eval_data2write_ ��Ϊ�˻�ȡ n_pipe �� ��������
load([eval_path, '\',pipeclass,'\data\mat\eval_data2write_',pipeclass,'.mat']);

%% �����ⲿ���ǽ���Ԥ���ͨ�ú���
% --------------------------------------------------------------
% n_train ����ѵ�������ĸ���
% n_predict Ԥ��δ�����ٴε����
[ n_train n_predict diag_trigger_time ] = readPredict_Config();
n_pipe = size(eval_data2write,1);
[last_dr_id, ~] = getMaxMinInDBCol( conn, 'RECORDID', diagtablename ); % ���һ����Ͻ����id��string���ͣ���
% setdbprefs('datareturnformat', 'numeric'); % ���õ��������Ϊ��������
data = zeros(n_pipe*s_fault, n_predict); % ����
bias = zeros(n_pipe*s_fault, n_predict); % ƫ��

writelog(['<Ԥ��',num2str(n_pipe),'������δ��',num2str(n_predict),'Сʱ�Ĺ��Ϸ�������>\n']);
tic
for i=1:n_pipe
    thispipe = eval_data2write{i,1};
%     fprintf('��ʼԤ�����%d...\n',i);
    for j=1:s_fault

        sql = ['SELECT "PROBABLITY" FROM (SELECT * FROM "',diagtablename,'" ORDER BY "RECORDID" DESC) WHERE "PIPEID"=''',...
            thispipe,''' AND "FAULTTYPE"=''',faultclass{j},...
            ''' AND ROWNUM<= ',num2str(n_train),' AND "RECORDID"<=''',last_dr_id,''''];
        
        DATA = fetch_data(conn,sql);
        if strcmp(DATA, 'No Data')
            errorlog(['���ݿ���',diagtablename,'�������ݣ�Ԥ���޷����У�']);
        else
            DATA = str2double(DATA); % תΪmat��ʽ
            if numel(DATA)<4
                errorlog(['��ϱ��',diagtablename,'����ʷ���ݹ��٣�Ԥ���޷����У�']);
            end
        end
        
        train_data = fliplr(DATA');
        train_fea = 1:size(train_data,2);
        test_fea = (train_fea(end)+1: train_fea(end)+n_predict);
        % ������д��������SVRԤ�⣬SVR������cmd��
    %     [ prediction bias ] = SVRpredict( train_data, train_fea, test_fea, cmd );
        [ prediction delta ] = LinerPredict( train_data, train_fea, test_fea );

%         if 0
%             plot(train_fea, train_data, 'b.');hold on;
%             plot(test_fea,prediction,'r',test_fea,prediction+bias,'g',test_fea, prediction-bias,'g');hold off;
%         end
        
        data(s_fault*(i-1)+j,:) = prediction; % ÿһ����һ�����ϵ�Ԥ����
        bias(s_fault*(i-1)+j,:) = delta; % ÿһ����һ�����ϵ�Ԥ��ƫ��
        
    end
end
writelog(['<ʹ����',num2str(size(train_data,2)),'����ʷ����>\n']);
toc
writelog('����Ԥ����ɣ�\n\n', 1);

% --------------------------------------------------------------
% ��data���ϳ�data2write�����ַ���cell��ʽ
data2write = get_PR_data( eval_data2write(:,1), data, bias, last_dr_id, n_pipe, faultclass, diag_trigger_time );

% ���ݱ��ر���
WriteData2txt( txtname, data2write );











