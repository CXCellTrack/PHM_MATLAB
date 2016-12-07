function evidence = getRandomEvidence( bnetCPD, n_fault, n_sensor )

rng(0);
% 随机生成传感器数据
n_node = n_fault + n_sensor;
cishu = 1; % 证据次数对结果的影响暂时还不清楚，先不用
evidence = cell(n_node, cishu);
for j=n_fault+1:n_node
    ps = bnetCPD.parents{j}; % 找出传感器节点的父节点
    nps = numel(ps);

    if bnetCPD.node_sizes(j)==1 % 高斯节点的随机证据
        for t=1:cishu
            evidence{j,t} = rand(1)*(2^nps); % 随机生成证据
        end
    else
        evidence{j,1} = randi(2)-1; % 离散节点的证据
    end
end