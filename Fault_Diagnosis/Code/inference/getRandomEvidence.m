function evidence = getRandomEvidence( bnetCPD, n_fault, n_sensor )

rng(0);
% ������ɴ���������
n_node = n_fault + n_sensor;
cishu = 1; % ֤�ݴ����Խ����Ӱ����ʱ����������Ȳ���
evidence = cell(n_node, cishu);
for j=n_fault+1:n_node
    ps = bnetCPD.parents{j}; % �ҳ��������ڵ�ĸ��ڵ�
    nps = numel(ps);

    if bnetCPD.node_sizes(j)==1 % ��˹�ڵ�����֤��
        for t=1:cishu
            evidence{j,t} = rand(1)*(2^nps); % �������֤��
        end
    else
        evidence{j,1} = randi(2)-1; % ��ɢ�ڵ��֤��
    end
end