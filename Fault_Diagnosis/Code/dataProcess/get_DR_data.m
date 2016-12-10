function data2write = get_DR_data( info, all_name, prob, s_fault )
%
% �ڲ��������ݿ������½������
% 
% �����ĸ��з���ռ�
faultclass = {};
FS = info.faultStructure.fault; % ��info����faultclass
for j=1:numel(FS)
    faultclass = [faultclass; FS(j).ATTRIBUTE.name];
end

% ----- dbid��ֵ ----- %
% ʹ�������Զ����

% ----- ��all_nameչ����һ�����ڹ���һ������ ---- %
tmpall_name = [];
probability = [];
ind = 0;
pipe_group = all_name.keys();
all_name_mat = [];
for xx=pipe_group
    all_name_mat = [all_name_mat, all_name(xx{1})];
end
for i=1:numel(pipe_group) % �������飬iΪ���
    % �ҳ���i����߶�Ӧ������
    i_group = all_name_mat==i;
%     i_group = cell2mat(all_name.values())==i; 
    members = strsplit(',',pipe_group{i_group}); % ���ö��ŷָ��˲��ܼӿո�֮��ģ���2016.4.6
    for mem = members % ��һ���������г�Ա
        ind = ind + 1;
        tmpall_name{ind,1} = mem{1};
%         pipeporb = zeros(s_fault,1);
        for k=1:s_fault % ��һ����Ա���й��ϸ���
            kk = s_fault*(i-1)+k; % prob�еı��
            pipeporb = roundn(prob{kk}.T(2), -2); % ������ǧ��λ
            probability = [ probability; pipeporb ];
        end
    end
end

% �ҳ���ʹ�ö�εĹ������ƣ�������ظ���������ģ�˵��һ�����߼���һ�����ڣ�����һ�������壩
tongji = tabulate(tmpall_name);
pipe_re = tongji(cell2mat(tongji(:,2))>1,1); % ���ظ�ʹ�õ�pipe
if ~isempty(pipe_re)
    errorlog(cell2mat(['����',reshape(pipe_re,1,[]),'���ظ�ʹ���ˣ�']));
end
        

% ----- pipeId��ֵ ----- %
tmp1 = repmat(tmpall_name, 1,s_fault); % ��Ҫ��pipeid��ԭΪԭʼ���
pipeId = reshape(tmp1', [], 1);
% ��pipeid��ǰ׺�������ƣ�ӳ��Ϊ��׼�����������ڶ�����Ѿ��Ǳ�׼����
% pipeId = cellfun(@(x) [pipeclass, x], pipeId, 'un',0);

% ----- faultType��ֵ ----- %
n_pipe = numel(tmpall_name);
faultType = repmat(faultclass, n_pipe, 1); % ����2��

% ----- description��ֵ ----- %
description = '�Թ��ϵ�����'; % д����ɾ������Ϊ������������̫���

% ----- probability��ֵ ----- %
% probability = zeros(n_fault,1);
% for i=1:n_fault
%     probability(i) = roundn(prob{i}.T(2), -4); % ���������λ
% end

% ----- isnormal��ֵ ----- %
isnormal = probability<0.3; % �ŵ�bat����ִ�и����

% % ----- recordTime��ֵ ----- %
% nowtime = fix(clock);
% tm = arrayfun(@num2str, nowtime, 'un', 0);
% for i=1:numel(tm)
%     if numel(tm{i})==1
%         tm{i} = ['0',tm{i}]; % ����Ǹ�λ��������ǰ�油0
%     end
% end
% diagTime = [ tm{1},'-',tm{2},'-',tm{3},' ',tm{4},':',tm{5},':',tm{6} ];
% 
% % ----- recordId��ֵ ----- %
% recordId = [tm{1},tm{2},tm{3},tm{4},tm{5}]; % ʹ��������ȷ��recordId

% 2016.2.26ʹ�ü򵥷�����������2��ʱ��
global diagTime recordId
% nt = now;
% diagTime = datestr(nt,31);
% recordId = strrep(datestr(nt,30),'T','');

% ������������ϳ�һ�����ߵļ�¼
data2write = {};
data2write(:,1) = pipeId;
data2write(:,2) = faultType;
data2write(:,3) = num2cell(probability);
data2write(:,4) = num2cell(isnormal);
data2write(:,5) = {description};
data2write(:,6) = {diagTime};
data2write(:,7) = {recordId};

% �����ݸ�ʽת��Ϊsring
data2write = cellfun(@num2str, data2write, 'un', 0);

% description��һ�������sql��д���������ɾȥ2015.10.27
data2write(:,5) = [];
data2write(:,4) = []; % isnormalҲ������sql��д���������Ҳɾȥ


end

