function bnet = add_gaussian_Pseudo_count( bnet )
%
% ��bnet�м���Pseudo_count������α������˹�ڵ�ĸ��ڵ�ĳ��ִ���
% ��ҪΪ�˸��¸�˹CPDʱ����

cnodes = bnet.cnodes; % ��ȡ��˹�ڵ�ļ���
bnet.gaussian_Pseudo_count = cell(size(bnet.CPD));

for i=1:numel(cnodes)
    node = cnodes(i);
    ps = bnet.parents{node}; % ��ǰ�ڵ�ĸ��ڵ�
    nps = numel(ps);
    
    if nps>1 % ����count����
        bnet.gaussian_Pseudo_count{node} = ones(2*ones(1,nps)); 
    elseif nps==1 % npsΪ0��˴����������壬���迼��
        bnet.gaussian_Pseudo_count{node} = [1;1];
    end
    
end







end

