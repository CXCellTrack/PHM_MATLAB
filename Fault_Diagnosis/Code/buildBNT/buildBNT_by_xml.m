function  [ info bnet all_name n_fault s_fault n_pipe n_sensor ] = buildBNT_by_xml( pipeclass, diagpath )

% ���ݹ�������ѡ���ַ
nsm_path = [diagpath, '\',pipeclass,'\data\mat\NSM_',pipeclass,'.mat'];

%% ��һ���������˹�������D����ת��ΪNSM����

if ~exist( nsm_path, 'file' )
    % ���������NSM�������D�����д���������
    [ info, NSM, all_name n_fault s_fault n_pipe n_sensor ] = buildNSM_by_xml( pipeclass );
    save( nsm_path, 'info', 'NSM', 'all_name', 'n_fault', 's_fault', 'n_pipe', 'n_sensor' );
else
    load( nsm_path );
end

%% �ڶ���������ڵ����͡��ڵ�״̬�����۲�ڵ㣬������Ҷ˹����

% ------------------- 1������ڵ����ͺ�״̬�� ---------------------- %
% ���Ͻڵ�ȫ������ɢ�ڵ�
node_size_fault = 2*ones(1,n_fault);
node_size_sensor = 2*ones(1,n_sensor);

% �������ڵ���Ҫ�����ж�
for i=1:n_sensor
    type = info.sensor(i).CPD.ATTRIBUTE.type;
    if strcmp(type,'gaussian')
        node_size_sensor(i) = 1;
    end
end

% �ڵ��״̬�����˴���ɢ�ڵ�Ϊ2�������ڵ�Ϊ1
node_size = [ node_size_fault, node_size_sensor ];
discrete_nodes = find(node_size==2); % ��ɢ�ڵ��� �����ڵ�ı�Ż���ݣ�ȫ��-��ɢ���Զ�Ѱ��

% observed_nodes = n_fault+1:n_node; % ����Ĵ������ڵ�Ϊ�ɹ۲�ڵ�
node_names = cell(1, n_fault+n_sensor);
for ii=1:n_fault+n_sensor
    if ii<=n_fault
        node_names{ii} = sprintf('pipe_group_%d', ii);
    else
        node_names{ii} = info.sensor(ii-n_fault).ATTRIBUTE.name;
    end
end
bnet = mk_bnet( NSM, node_size, 'discrete', discrete_nodes, 'names', node_names); % bnet��һ���ṹ��

%% ------------------------------------------------------------ %
% ����Ƕ���ĳ�ʼCPD���ݣ�����Ҫ������д���bnet��
% ----------------------------------------------------------------------- %
% ���Ͻڵ��CPD
FS = info.faultStructure;
for i=1:s_fault:n_fault 
    for uu=i:i+s_fault-1
        fault_type = mod(uu,s_fault); % �ü�������fault��cpd��չһ��
        fault_type(fault_type==0) = s_fault;
        
        bnet.CPD{uu} = tabular_CPD(bnet, uu, 'CPT', FS.fault(fault_type).CPD,...
            'prior_type', 'dirichlet', 'dirichlet_type', 'unif', 'dirichlet_weight', 1);
    end
end

% �������ڵ��CPD
for j=n_fault+1:n_fault+n_sensor 
    % �����ĸ�˹��ֵ��������Ŀ 2^n
    truenum = 2^info.sensor(j-n_fault).ATTRIBUTE.pipeNumber; 
    sensorname = info.sensor(j-n_fault).ATTRIBUTE.name;
    if any(bnet.cnodes==j)
        tpmean = info.sensor(j-n_fault).CPD.mean;
        tpcov = info.sensor(j-n_fault).CPD.cov;
        % --------- ����ֵ�������Ŀ�Ƿ��쳣 ------------ %
        if numel(tpmean)~=numel(tpcov)
            errorlog([sensorname, ' �������ĸ�˹��ֵ�뷽�����Ŀ����ȣ�']);
        elseif numel(tpmean)~=truenum
            errorlog([sensorname, ' �������ĸ�˹��ֵ��ĿӦ��Ϊ ', num2str(truenum)]);
        end
        % ---------------------------------------------- %
        bnet.CPD{j} = gaussian_CPD(bnet, j, 'cov_type', 'diag', 'mean',...
            tpmean, 'cov', tpcov ); % ���贫��������Ϊ��˹�ֲ�
    elseif any(bnet.dnodes==j)
        tpcpd = info.sensor(j-n_fault).CPD;
        % --------- �����ɢCPD����Ŀ�Ƿ��쳣 ------------ %
        if numel(tpcpd)~=truenum*2
            errorlog([sensorname, ' ����������ɢCPD��ĿӦ��Ϊ ', num2str(truenum*2)]);
        end
        % ---------------------------------------------- %
        bnet.CPD{j} = tabular_CPD(bnet, j, 'CPT', tpcpd,...
            'prior_type', 'dirichlet', 'dirichlet_type', 'unif', 'dirichlet_weight', 1);
    else
        errorlog(['�������ڵ�',num2str(j),'�����ڸ�˹�ڵ�Ҳ��������ɢ�ڵ㣡']);
    end     
end







