function eval_data2write = Health_Eval( pipeclass )

% 健康度评估，只与上一次诊断的结果有关
% 从数据库中选取记录,或者分析上一次诊断本地保存的数据

% 从系统变量中读取PHM_HOME
diagpath = getphmpath('diag');
evalpath = getphmpath('eval');

diag_result = [ diagpath, '\',pipeclass,'\data\mat\data2write_',pipeclass,'.mat' ];
HealthWeight = [ evalpath, '\',pipeclass,'\data\udf\健康度权值表.xml' ];
txtname = [ evalpath, '\',pipeclass,'\data\backup_',pipeclass,'.txt' ];

%% 载入诊断结果     
load( diag_result ); 
% 读入健康度权值表
info = xml_read(HealthWeight);
if ~strcmp(info.ATTRIBUTE.type, pipeclass)
    errorlog(sprintf('%s 中的管线type=%s，与实际类型%s不符合，请修改xml中的类型！',...
        alterPath(HealthWeight),info.ATTRIBUTE.type,pipeclass));
end
% s_fault 从xml的fault_num中读取
s_fault = info.ATTRIBUTE.fault_num;
RR = info.repair.cost; 
DD = info.damage.cost; 
EE = info.expert.cost; 
if s_fault~=1 % 当s_fault不为1时，得到的cost是一个cell，需要转换为mat
    RR = cell2mat(RR);
    DD = cell2mat(DD);
    EE = cell2mat(EE);
end
RW = info.repair.ATTRIBUTE.weight;
DW = info.damage.ATTRIBUTE.weight;
EW = info.expert.ATTRIBUTE.weight;
H = info.standard; % 分级标准

%% 求出健康度最小值与最大值
minhealth = 0; 
maxhealth = sum(RR*RW + DD*DW + EE*EW);

n_fault = size(data2write, 1);
n_pipe = n_fault/s_fault;
if int32(n_pipe)~=n_pipe % 判断n_pipe是否为整数，如果不是，则fault_num很有可能填写错误！
    errorlog(sprintf(' %s 中的 fault_num 为%d，请检查是否填写有误！必须要与D矩阵中的一致！',...
        alterPath(HealthWeight), s_fault));
end
    
% 健康值
healthValue = zeros(n_pipe,1); 
ind_prob = 3; % 概率值在data2write中的第3列（dbid,pipeid,faulttype,prob）
data = cellfun(@str2num, data2write(:,ind_prob));
for h=1:n_pipe
    for ii=1:s_fault
        healthValue(h) = healthValue(h) + data((h-1)*s_fault+ii)*(RR(ii)*RW + DD(ii)*DW + EE(ii)*EW);
    end
end

%% 把健康值投射到0-100中间
healthValue = roundn( (1-healthValue/maxhealth)*100, 0 );

% 分区间
healthEval = cell(n_pipe,1);
for h=1:n_pipe
    if healthValue(h)<H.ill
        healthEval{h} = '严重疾病';
    elseif healthValue(h)<H.semi_healthy
        healthEval{h} = '疾病';
    elseif healthValue(h)<H.healthy
        healthEval{h} = '亚健康';
    elseif healthValue(h)<H.very_healthy
        healthEval{h} = '较健康';
    else
        healthEval{h} = '健康';
    end
end
    
%% 记录下评估时间
nowtime = fix(clock);
tm = arrayfun(@num2str, nowtime, 'un', 0);
evalTime = [ tm{1},'-',tm{2},'-',tm{3},' ',tm{4},':',tm{5},':',tm{6} ];

% 组合成eval_data2write
eval_data2write = data2write(1:s_fault:end,1);
eval_data2write(:,2) = num2cell(healthValue);
eval_data2write(:,3) = healthEval;
eval_data2write(:,4) = {evalTime};
ind_recordid = 5; % recordid在data2write中的位置
eval_data2write(:,5) = data2write(1,ind_recordid); % 将recordid传递过来

writelog('评估完成！\n\n');    
eval_data2write = cellfun(@num2str, eval_data2write, 'un', 0);

% 本地存一份mat格式的
data_path = [evalpath, '\',pipeclass,'\data\mat\eval_data2write_',pipeclass,'.mat'];
save(data_path, 'eval_data2write');

% 本地保存为txt格式
WriteData2txt( txtname, eval_data2write );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    