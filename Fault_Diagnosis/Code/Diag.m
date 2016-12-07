 function data2write = Diag( conn, pipeclass )

diagpath = getphmpath('diag');

% ------------------- 1、载入/计算bnet ---------------------- %
% [ bnet Dmatrix all_name n_fault s_fault n_pipe n_sensor ] = buildBNT( pipeclass );
[ info bnet1 all_name n_fault s_fault n_pipe n_sensor ] = buildBNT_by_xml( pipeclass, diagpath );

% ------------------- 2、配置CPD表 ---------------------- %
bnet_path = [diagpath, '\',pipeclass,'\data\mat\bnetCPD_',pipeclass,'.mat'];
% 不存在时需要重新读入数据进行创建
if ~exist(bnet_path,'file')
    writelog('正在从数据库中更新CPD...\n\n');
%     bnet1 = AssignCPD( pipeclass, bnet, n_fault, s_fault, n_sensor);
    bnet2 = getCPDfromDB( conn, bnet1, info, pipeclass, diagpath, n_fault );
    bnetCPD = add_gaussian_Pseudo_count( bnet2 ); % 在bnet中增加高斯伪计数功能（用于参数更新）
    save(bnet_path, 'bnetCPD');
else
    load(bnet_path);
end
% bnet：不包含CPD（结构确定之后就不变了）
% bnet1：从txt读入的CPD
% bnet2：从DB读入CPD
% bnetCPD：包含CPD和高斯伪计数
% ------------------------- %
% 使用以下代码查看CPD是否正确
CPD_TO_SEE = cell(numel(bnetCPD.CPD), 1);
for i=1:numel(bnetCPD.CPD)
    CPD_TO_SEE{i} = struct(bnetCPD.CPD{i});
end
% ------------------------- %

% ------------------- 3、配置贝叶斯推理引擎 ---------------------- %
% 配置引擎的速度较慢，按照模型大小而定，配置完成后的计算速度很快
writelog('配置贝叶斯网络推理引擎...\n');
engine = AssignEngine( bnetCPD );
writelog('输入传感器证据进行推理...\n');

% ------------------- 4、输入证据进行推理 ---------------------- %
if 1
    % 此处需从传感器数据库拉取数据，并组合成证据所要求的数据格式
	evidence = getEvidencefromDB( conn, bnetCPD, info, pipeclass, n_fault );
else 
    % 随机生成证据
    evidence = getRandomEvidence( bnetCPD, n_fault, n_sensor );
end
% 往引擎中输入证据，得到更新后的引擎
[engine_got_evidence, ~] = enter_evidence(engine, evidence);

% ------------------- 5、得到各故障节点边缘概率分布 ---------------------- %
prob = cell(n_fault, 1);
for i=1:n_fault
    prob{i} = marginal_nodes(engine_got_evidence, i);
end

writelog('故障诊断完成！\n\n');

% ------------------- 6、组合数据、本地备份txt ---------------------- %
% 调用函数将待写入数据组合成cell形式

data2write = get_DR_data( info, all_name, prob, s_fault );
% 顺便在本地保存一份mat，之后用健康度评估时就无需抓取数据库了
data_path = [diagpath, '\',pipeclass,'\data\mat\data2write_',pipeclass,'.mat'];
save(data_path, 'data2write');
% 调用函数 WriteData2txt 将数据保存在 txt 中
backup_path = [diagpath, '\',pipeclass,'\data\backup_',pipeclass,'.txt'];
WriteData2txt( backup_path, data2write );




