 function data2write = Diag( conn, pipeclass )

diagpath = getphmpath('diag');

% ------------------- 1������/����bnet ---------------------- %
% [ bnet Dmatrix all_name n_fault s_fault n_pipe n_sensor ] = buildBNT( pipeclass );
[ info bnet1 all_name n_fault s_fault n_pipe n_sensor ] = buildBNT_by_xml( pipeclass, diagpath );

% ------------------- 2������CPD�� ---------------------- %
bnet_path = [diagpath, '\',pipeclass,'\data\mat\bnetCPD_',pipeclass,'.mat'];
% ������ʱ��Ҫ���¶������ݽ��д���
if ~exist(bnet_path,'file')
    writelog('���ڴ����ݿ��и���CPD...\n\n');
%     bnet1 = AssignCPD( pipeclass, bnet, n_fault, s_fault, n_sensor);
    bnet2 = getCPDfromDB( conn, bnet1, info, pipeclass, diagpath, n_fault );
    bnetCPD = add_gaussian_Pseudo_count( bnet2 ); % ��bnet�����Ӹ�˹α�������ܣ����ڲ������£�
    save(bnet_path, 'bnetCPD');
else
    load(bnet_path);
end
% bnet��������CPD���ṹȷ��֮��Ͳ����ˣ�
% bnet1����txt�����CPD
% bnet2����DB����CPD
% bnetCPD������CPD�͸�˹α����
% ------------------------- %
% ʹ�����´���鿴CPD�Ƿ���ȷ
CPD_TO_SEE = cell(numel(bnetCPD.CPD), 1);
for i=1:numel(bnetCPD.CPD)
    CPD_TO_SEE{i} = struct(bnetCPD.CPD{i});
end
% ------------------------- %

% ------------------- 3�����ñ�Ҷ˹�������� ---------------------- %
% ����������ٶȽ���������ģ�ʹ�С������������ɺ�ļ����ٶȺܿ�
writelog('���ñ�Ҷ˹������������...\n');
engine = AssignEngine( bnetCPD );
writelog('���봫����֤�ݽ�������...\n');

% ------------------- 4������֤�ݽ������� ---------------------- %
if 1
    % �˴���Ӵ��������ݿ���ȡ���ݣ�����ϳ�֤����Ҫ������ݸ�ʽ
	evidence = getEvidencefromDB( conn, bnetCPD, info, pipeclass, n_fault );
else 
    % �������֤��
    evidence = getRandomEvidence( bnetCPD, n_fault, n_sensor );
end
% ������������֤�ݣ��õ����º������
[engine_got_evidence, ~] = enter_evidence(engine, evidence);

% ------------------- 5���õ������Ͻڵ��Ե���ʷֲ� ---------------------- %
prob = cell(n_fault, 1);
for i=1:n_fault
    prob{i} = marginal_nodes(engine_got_evidence, i);
end

writelog('���������ɣ�\n\n');

% ------------------- 6��������ݡ����ر���txt ---------------------- %
% ���ú�������д��������ϳ�cell��ʽ

data2write = get_DR_data( info, all_name, prob, s_fault );
% ˳���ڱ��ر���һ��mat��֮���ý���������ʱ������ץȡ���ݿ���
data_path = [diagpath, '\',pipeclass,'\data\mat\data2write_',pipeclass,'.mat'];
save(data_path, 'data2write');
% ���ú��� WriteData2txt �����ݱ����� txt ��
backup_path = [diagpath, '\',pipeclass,'\data\backup_',pipeclass,'.txt'];
WriteData2txt( backup_path, data2write );




