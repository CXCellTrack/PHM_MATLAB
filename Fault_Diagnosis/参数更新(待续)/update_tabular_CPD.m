function bnet = update_tabular_CPD( bnet, cases )
% 
%   Detailed explanation goes here

n_samples = size(cases, 2);

dnodes = bnet.dnodes; % 获取离散节点的集合

for i=1:numel(dnodes)
    
    node = dnodes(i); % 当前节点
    ps = bnet.parents{node}; % 当前节点的父节点
    
    if isempty(ps) % 为根节点
        
        tmp = struct(bnet.CPD{node});
        count = zeros(2,1);
        
        count(1) = numel(find(cases(node,:)==1));
        count(2) = n_samples - count(1);
        
        p = (tmp.CPT.*tmp.dirichlet + count)/(dot(tmp.CPT,tmp.dirichlet) + n_samples);
        
        bnet.CPD{node} = cx_tabular_set_fields( bnet.CPD{node}, 'CPT', p, 'dirichlet', count);
        
    elseif numel(ps)==1 % 有一个父节点
        
        count = zeros(2,2);
        p = zeros(2,2);
        tmp = struct(bnet.CPD{node});
        
        tmpcase = cases([ps,node],:)';
        strcell = mat2cell(num2str(tmpcase), ones(1,n_samples), 4);
        % 统计11、12、21、22四种情况出现的频率
        for ii=1:2
            for jj=1:2
                count(ii,jj) = sum(strncmp(strcell, [num2str(ii),'  ',num2str(jj)], 4));
            end
        end
        for ii=1:2
            for jj=1:2
                p(ii,jj) = (tmp.CPT(ii,jj)*tmp.dirichlet(ii,jj) + count(ii,jj)) / sum(tmp.CPT(ii,:).*tmp.dirichlet(ii,:)+count(ii,:));
            end
        end
        
        bnet.CPD{node} = cx_tabular_set_fields( bnet.CPD{node}, 'CPT', p, 'dirichlet', count);
        
    end
        
end







end

