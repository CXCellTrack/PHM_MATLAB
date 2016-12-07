function  [ info bnet all_name n_fault s_fault n_pipe n_sensor ] = buildBNT_by_xml( pipeclass, diagpath )

% 根据管线种类选择地址
nsm_path = [diagpath, '\',pipeclass,'\data\mat\NSM_',pipeclass,'.mat'];

%% 第一步：读入人工制作的D矩阵，转变为NSM矩阵

if ~exist( nsm_path, 'file' )
    % 如果不存在NSM矩阵，则从D矩阵中创建并保存
    [ info, NSM, all_name n_fault s_fault n_pipe n_sensor ] = buildNSM_by_xml( pipeclass );
    save( nsm_path, 'info', 'NSM', 'all_name', 'n_fault', 's_fault', 'n_pipe', 'n_sensor' );
else
    load( nsm_path );
end

%% 第二步：定义节点类型、节点状态数、观测节点，建立贝叶斯网络

% ------------------- 1、定义节点类型和状态数 ---------------------- %
% 故障节点全都是离散节点
node_size_fault = 2*ones(1,n_fault);
node_size_sensor = 2*ones(1,n_sensor);

% 传感器节点需要进行判断
for i=1:n_sensor
    type = info.sensor(i).CPD.ATTRIBUTE.type;
    if strcmp(type,'gaussian')
        node_size_sensor(i) = 1;
    end
end

% 节点的状态数，此处离散节点为2，连续节点为1
node_size = [ node_size_fault, node_size_sensor ];
discrete_nodes = find(node_size==2); % 离散节点编号 连续节点的编号会根据（全体-离散）自动寻找

% observed_nodes = n_fault+1:n_node; % 后面的传感器节点为可观测节点
node_names = cell(1, n_fault+n_sensor);
for ii=1:n_fault+n_sensor
    if ii<=n_fault
        node_names{ii} = sprintf('pipe_group_%d', ii);
    else
        node_names{ii} = info.sensor(ii-n_fault).ATTRIBUTE.name;
    end
end
bnet = mk_bnet( NSM, node_size, 'discrete', discrete_nodes, 'names', node_names); % bnet是一个结构体

%% ------------------------------------------------------------ %
% 如果是读入的初始CPD数据，则需要把数据写入空bnet中
% ----------------------------------------------------------------------- %
% 故障节点的CPD
FS = info.faultStructure;
for i=1:s_fault:n_fault 
    for uu=i:i+s_fault-1
        fault_type = mod(uu,s_fault); % 用几个基本fault的cpd扩展一下
        fault_type(fault_type==0) = s_fault;
        
        bnet.CPD{uu} = tabular_CPD(bnet, uu, 'CPT', FS.fault(fault_type).CPD,...
            'prior_type', 'dirichlet', 'dirichlet_type', 'unif', 'dirichlet_weight', 1);
    end
end

% 传感器节点的CPD
for j=n_fault+1:n_fault+n_sensor 
    % 正常的高斯均值、方差数目 2^n
    truenum = 2^info.sensor(j-n_fault).ATTRIBUTE.pipeNumber; 
    sensorname = info.sensor(j-n_fault).ATTRIBUTE.name;
    if any(bnet.cnodes==j)
        tpmean = info.sensor(j-n_fault).CPD.mean;
        tpcov = info.sensor(j-n_fault).CPD.cov;
        % --------- 检查均值方差的数目是否异常 ------------ %
        if numel(tpmean)~=numel(tpcov)
            errorlog([sensorname, ' 传感器的高斯均值与方差的数目不想等！']);
        elseif numel(tpmean)~=truenum
            errorlog([sensorname, ' 传感器的高斯均值数目应该为 ', num2str(truenum)]);
        end
        % ---------------------------------------------- %
        bnet.CPD{j} = gaussian_CPD(bnet, j, 'cov_type', 'diag', 'mean',...
            tpmean, 'cov', tpcov ); % 假设传感器数据为高斯分布
    elseif any(bnet.dnodes==j)
        tpcpd = info.sensor(j-n_fault).CPD;
        % --------- 检查离散CPD的数目是否异常 ------------ %
        if numel(tpcpd)~=truenum*2
            errorlog([sensorname, ' 传感器的离散CPD数目应该为 ', num2str(truenum*2)]);
        end
        % ---------------------------------------------- %
        bnet.CPD{j} = tabular_CPD(bnet, j, 'CPT', tpcpd,...
            'prior_type', 'dirichlet', 'dirichlet_type', 'unif', 'dirichlet_weight', 1);
    else
        errorlog(['传感器节点',num2str(j),'不属于高斯节点也不属于离散节点！']);
    end     
end







