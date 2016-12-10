function data2write = get_DR_data( info, all_name, prob, s_fault )
%
% 在不连接数据库的情况下建立表格
% 
% 给表格的各列分配空间
faultclass = {};
FS = info.faultStructure.fault; % 由info生成faultclass
for j=1:numel(FS)
    faultclass = [faultclass; FS(j).ATTRIBUTE.name];
end

% ----- dbid赋值 ----- %
% 使用序列自动完成

% ----- 将all_name展开，一个组内共享一个概率 ---- %
tmpall_name = [];
probability = [];
ind = 0;
pipe_group = all_name.keys();
all_name_mat = [];
for xx=pipe_group
    all_name_mat = [all_name_mat, all_name(xx{1})];
end
for i=1:numel(pipe_group) % 对所有组，i为组号
    % 找出第i组管线对应的名称
    i_group = all_name_mat==i;
%     i_group = cell2mat(all_name.values())==i; 
    members = strsplit(',',pipe_group{i_group}); % 仅用逗号分割，因此不能加空格之类的！！2016.4.6
    for mem = members % 对一个组内所有成员
        ind = ind + 1;
        tmpall_name{ind,1} = mem{1};
%         pipeporb = zeros(s_fault,1);
        for k=1:s_fault % 对一个成员所有故障概率
            kk = s_fault*(i-1)+k; % prob中的编号
            pipeporb = roundn(prob{kk}.T(2), -2); % 保留到千分位
            probability = [ probability; pipeporb ];
        end
    end
end

% 找出被使用多次的管线名称（这里的重复是有问题的，说明一个管线既在一个组内，又是一个单独体）
tongji = tabulate(tmpall_name);
pipe_re = tongji(cell2mat(tongji(:,2))>1,1); % 被重复使用的pipe
if ~isempty(pipe_re)
    errorlog(cell2mat(['管线',reshape(pipe_re,1,[]),'被重复使用了！']));
end
        

% ----- pipeId赋值 ----- %
tmp1 = repmat(tmpall_name, 1,s_fault); % 需要将pipeid还原为原始编号
pipeId = reshape(tmp1', [], 1);
% 给pipeid加前缀管线名称（映射为标准管线名）现在读入的已经是标准名称
% pipeId = cellfun(@(x) [pipeclass, x], pipeId, 'un',0);

% ----- faultType赋值 ----- %
n_pipe = numel(tmpall_name);
faultType = repmat(faultclass, n_pipe, 1); % 表格第2列

% ----- description赋值 ----- %
description = '对故障的描述'; % 写完后会删除，因为在这里描述不太灵活

% ----- probability赋值 ----- %
% probability = zeros(n_fault,1);
% for i=1:n_fault
%     probability(i) = roundn(prob{i}.T(2), -4); % 保留到万分位
% end

% ----- isnormal赋值 ----- %
isnormal = probability<0.3; % 放到bat里面执行更灵活

% % ----- recordTime赋值 ----- %
% nowtime = fix(clock);
% tm = arrayfun(@num2str, nowtime, 'un', 0);
% for i=1:numel(tm)
%     if numel(tm{i})==1
%         tm{i} = ['0',tm{i}]; % 如果是个位数，就在前面补0
%     end
% end
% diagTime = [ tm{1},'-',tm{2},'-',tm{3},' ',tm{4},':',tm{5},':',tm{6} ];
% 
% % ----- recordId赋值 ----- %
% recordId = [tm{1},tm{2},tm{3},tm{4},tm{5}]; % 使用日期来确定recordId

% 2016.2.26使用简单方法来制作这2个时间
global diagTime recordId
% nt = now;
% diagTime = datestr(nt,31);
% recordId = strrep(datestr(nt,30),'T','');

% 将以上数据组合成一条管线的记录
data2write = {};
data2write(:,1) = pipeId;
data2write(:,2) = faultType;
data2write(:,3) = num2cell(probability);
data2write(:,4) = num2cell(isnormal);
data2write(:,5) = {description};
data2write(:,6) = {diagTime};
data2write(:,7) = {recordId};

% 将数据格式转化为sring
data2write = cellfun(@num2str, data2write, 'un', 0);

% description这一项可以在sql中写，因此这里删去2015.10.27
data2write(:,5) = [];
data2write(:,4) = []; % isnormal也可以在sql中写，因此这里也删去


end

