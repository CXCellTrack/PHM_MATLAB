function bnet = add_gaussian_Pseudo_count( bnet )
%
% 在bnet中加入Pseudo_count，用来伪计数高斯节点的父节点的出现次数
% 主要为了更新高斯CPD时方便

cnodes = bnet.cnodes; % 获取高斯节点的集合
bnet.gaussian_Pseudo_count = cell(size(bnet.CPD));

for i=1:numel(cnodes)
    node = cnodes(i);
    ps = bnet.parents{node}; % 当前节点的父节点
    nps = numel(ps);
    
    if nps>1 % 建立count矩阵
        bnet.gaussian_Pseudo_count{node} = ones(2*ones(1,nps)); 
    elseif nps==1 % nps为0则此传感器无意义，不予考虑
        bnet.gaussian_Pseudo_count{node} = [1;1];
    end
    
end







end

