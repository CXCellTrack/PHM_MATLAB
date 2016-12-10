function data2write = get_PR_data( pipename, data, bias, last_dr_id, n_pipe, faultclass, diag_trigger_time )


% 给表格的各列分配空间
s_fault = numel(faultclass);
n_fault = s_fault*n_pipe;
n_predict = size(data,2);

% ----- pipeId赋值 ----- %
tmp1 = repmat(pipename, 1, s_fault);
tmp2 = reshape(tmp1', [], 1);
pipe_id = repmat(tmp2, n_predict, 1);

% ----- faultType赋值 ----- %
faultclass = repmat(faultclass, n_pipe*n_predict, 1);

% ----- probability赋值 ----- %
prob = reshape(roundn(data,-2), n_fault*n_predict,1); % 都保留4位有效数字
% 预测出的prob有可能为负值，或大于1，此时要进行cut
prob(prob>1) = 1; prob(prob<0) = 0;

% ----- prob_bias赋值 ----- %
prob_bias = reshape(roundn(bias,-2), n_fault*n_predict, 1);

% ----- predict_time赋值 ----- %
% nowtime = fix(clock);
% tm = arrayfun(@num2str, nowtime, 'un', 0);
% for i=1:numel(tm)
%     if numel(tm{i})==1
%         tm{i} = ['0',tm{i}]; % 如果是个位数，就在前面补0
%     end
% end
% predict_time = [ tm{1},'-',tm{2},'-',tm{3},' ',tm{4},':',tm{5},':',tm{6} ];
global predictTime
% predictTime = datestr(now,31);

% ----- analysis赋值 ----- %
analysis = '对预测结果的分析';

% ----- record_id赋值 ----- %
record_id = cell(n_predict,1);
lid.year = str2double(last_dr_id(1:4));
lid.mon = str2double(last_dr_id(5:6));
lid.day = str2double(last_dr_id(7:8));
lid.hour = str2double(last_dr_id(9:10));
lid.min = str2double(last_dr_id(11:12));

for i=1:n_predict
    daynum = datenum(lid.year,lid.mon,lid.day,lid.hour,lid.min,0);
    addtime = i*diag_trigger_time/60/24; % 将触发时间的单位由分钟改为天
    newdate = datestr( daynum+addtime, 'yyyymmddTHHMMSS');
    newdate(9)=''; newdate(end-1:end)='';
    record_id{i} = newdate;
end
record_id = repmat(record_id, 1, n_fault);
record_id = reshape(record_id', n_fault*n_predict, 1);

% ======== 将数据整合为 data2write 格式 ========== %
data2write = cell(n_fault*n_predict,1);

data2write(:,1) = pipe_id;
data2write(:,2) = faultclass;
data2write(:,[3 4]) = num2cell([prob, prob_bias]);
data2write(:,5) = num2cell(prob<0.3); % 发生概率小于0.3算正常
data2write(:,6) = {predictTime};
data2write(:,7) = {analysis};
data2write(:,8) = record_id;

% description这一项可以在sql中写，因此这里删去 2016.7.4
data2write(:,[5 7]) = []; % isnormal也可以在sql中写，因此这里也删去 

data2write = cellfun(@num2str, data2write, 'un', 0);

% % 日期的加减法用以下算式进行
% daynum = datenum(2015,09,23,6,0,0);
% date = datestr( daynum+9.5, 'yyyy-mm-dd HH:MM:SS');
% % 实现自动换月份，方便！










































