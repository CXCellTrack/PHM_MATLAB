function eval_data2write = Health_Eval( pipeclass )

% ������������ֻ����һ����ϵĽ���й�
% �����ݿ���ѡȡ��¼,���߷�����һ����ϱ��ر��������

% ��ϵͳ�����ж�ȡPHM_HOME
diagpath = getphmpath('diag');
evalpath = getphmpath('eval');

diag_result = [ diagpath, '\',pipeclass,'\data\mat\data2write_',pipeclass,'.mat' ];
HealthWeight = [ evalpath, '\',pipeclass,'\data\udf\������Ȩֵ��.xml' ];
txtname = [ evalpath, '\',pipeclass,'\data\backup_',pipeclass,'.txt' ];

%% ������Ͻ��     
load( diag_result ); 
% ���뽡����Ȩֵ��
info = xml_read(HealthWeight);
if ~strcmp(info.ATTRIBUTE.type, pipeclass)
    errorlog(sprintf('%s �еĹ���type=%s����ʵ������%s�����ϣ����޸�xml�е����ͣ�',...
        alterPath(HealthWeight),info.ATTRIBUTE.type,pipeclass));
end
% s_fault ��xml��fault_num�ж�ȡ
s_fault = info.ATTRIBUTE.fault_num;
RR = info.repair.cost; 
DD = info.damage.cost; 
EE = info.expert.cost; 
if s_fault~=1 % ��s_fault��Ϊ1ʱ���õ���cost��һ��cell����Ҫת��Ϊmat
    RR = cell2mat(RR);
    DD = cell2mat(DD);
    EE = cell2mat(EE);
end
RW = info.repair.ATTRIBUTE.weight;
DW = info.damage.ATTRIBUTE.weight;
EW = info.expert.ATTRIBUTE.weight;
H = info.standard; % �ּ���׼

%% �����������Сֵ�����ֵ
minhealth = 0; 
maxhealth = sum(RR*RW + DD*DW + EE*EW);

n_fault = size(data2write, 1);
n_pipe = n_fault/s_fault;
if int32(n_pipe)~=n_pipe % �ж�n_pipe�Ƿ�Ϊ������������ǣ���fault_num���п�����д����
    errorlog(sprintf(' %s �е� fault_num Ϊ%d�������Ƿ���д���󣡱���Ҫ��D�����е�һ�£�',...
        alterPath(HealthWeight), s_fault));
end
    
% ����ֵ
healthValue = zeros(n_pipe,1); 
ind_prob = 3; % ����ֵ��data2write�еĵ�3�У�dbid,pipeid,faulttype,prob��
data = cellfun(@str2num, data2write(:,ind_prob));
for h=1:n_pipe
    for ii=1:s_fault
        healthValue(h) = healthValue(h) + data((h-1)*s_fault+ii)*(RR(ii)*RW + DD(ii)*DW + EE(ii)*EW);
    end
end

%% �ѽ���ֵͶ�䵽0-100�м�
healthValue = roundn( (1-healthValue/maxhealth)*100, 0 );

% ������
healthEval = cell(n_pipe,1);
for h=1:n_pipe
    if healthValue(h)<H.ill
        healthEval{h} = '���ؼ���';
    elseif healthValue(h)<H.semi_healthy
        healthEval{h} = '����';
    elseif healthValue(h)<H.healthy
        healthEval{h} = '�ǽ���';
    elseif healthValue(h)<H.very_healthy
        healthEval{h} = '�Ͻ���';
    else
        healthEval{h} = '����';
    end
end
    
%% ��¼������ʱ��
nowtime = fix(clock);
tm = arrayfun(@num2str, nowtime, 'un', 0);
evalTime = [ tm{1},'-',tm{2},'-',tm{3},' ',tm{4},':',tm{5},':',tm{6} ];

% ��ϳ�eval_data2write
eval_data2write = data2write(1:s_fault:end,1);
eval_data2write(:,2) = num2cell(healthValue);
eval_data2write(:,3) = healthEval;
eval_data2write(:,4) = {evalTime};
ind_recordid = 5; % recordid��data2write�е�λ��
eval_data2write(:,5) = data2write(1,ind_recordid); % ��recordid���ݹ���

writelog('������ɣ�\n\n');    
eval_data2write = cellfun(@num2str, eval_data2write, 'un', 0);

% ���ش�һ��mat��ʽ��
data_path = [evalpath, '\',pipeclass,'\data\mat\eval_data2write_',pipeclass,'.mat'];
save(data_path, 'eval_data2write');

% ���ر���Ϊtxt��ʽ
WriteData2txt( txtname, eval_data2write );
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    