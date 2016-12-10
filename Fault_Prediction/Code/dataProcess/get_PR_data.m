function data2write = get_PR_data( pipename, data, bias, last_dr_id, n_pipe, faultclass, diag_trigger_time )


% �����ĸ��з���ռ�
s_fault = numel(faultclass);
n_fault = s_fault*n_pipe;
n_predict = size(data,2);

% ----- pipeId��ֵ ----- %
tmp1 = repmat(pipename, 1, s_fault);
tmp2 = reshape(tmp1', [], 1);
pipe_id = repmat(tmp2, n_predict, 1);

% ----- faultType��ֵ ----- %
faultclass = repmat(faultclass, n_pipe*n_predict, 1);

% ----- probability��ֵ ----- %
prob = reshape(roundn(data,-2), n_fault*n_predict,1); % ������4λ��Ч����
% Ԥ�����prob�п���Ϊ��ֵ�������1����ʱҪ����cut
prob(prob>1) = 1; prob(prob<0) = 0;

% ----- prob_bias��ֵ ----- %
prob_bias = reshape(roundn(bias,-2), n_fault*n_predict, 1);

% ----- predict_time��ֵ ----- %
% nowtime = fix(clock);
% tm = arrayfun(@num2str, nowtime, 'un', 0);
% for i=1:numel(tm)
%     if numel(tm{i})==1
%         tm{i} = ['0',tm{i}]; % ����Ǹ�λ��������ǰ�油0
%     end
% end
% predict_time = [ tm{1},'-',tm{2},'-',tm{3},' ',tm{4},':',tm{5},':',tm{6} ];
global predictTime
% predictTime = datestr(now,31);

% ----- analysis��ֵ ----- %
analysis = '��Ԥ�����ķ���';

% ----- record_id��ֵ ----- %
record_id = cell(n_predict,1);
lid.year = str2double(last_dr_id(1:4));
lid.mon = str2double(last_dr_id(5:6));
lid.day = str2double(last_dr_id(7:8));
lid.hour = str2double(last_dr_id(9:10));
lid.min = str2double(last_dr_id(11:12));

for i=1:n_predict
    daynum = datenum(lid.year,lid.mon,lid.day,lid.hour,lid.min,0);
    addtime = i*diag_trigger_time/60/24; % ������ʱ��ĵ�λ�ɷ��Ӹ�Ϊ��
    newdate = datestr( daynum+addtime, 'yyyymmddTHHMMSS');
    newdate(9)=''; newdate(end-1:end)='';
    record_id{i} = newdate;
end
record_id = repmat(record_id, 1, n_fault);
record_id = reshape(record_id', n_fault*n_predict, 1);

% ======== ����������Ϊ data2write ��ʽ ========== %
data2write = cell(n_fault*n_predict,1);

data2write(:,1) = pipe_id;
data2write(:,2) = faultclass;
data2write(:,[3 4]) = num2cell([prob, prob_bias]);
data2write(:,5) = num2cell(prob<0.3); % ��������С��0.3������
data2write(:,6) = {predictTime};
data2write(:,7) = {analysis};
data2write(:,8) = record_id;

% description��һ�������sql��д���������ɾȥ 2016.7.4
data2write(:,[5 7]) = []; % isnormalҲ������sql��д���������Ҳɾȥ 

data2write = cellfun(@num2str, data2write, 'un', 0);

% % ���ڵļӼ�����������ʽ����
% daynum = datenum(2015,09,23,6,0,0);
% date = datestr( daynum+9.5, 'yyyy-mm-dd HH:MM:SS');
% % ʵ���Զ����·ݣ����㣡










































