function bnet = update_tabular_CPD( bnet, cases )
% 
%   Detailed explanation goes here

n_samples = size(cases, 2);

dnodes = bnet.dnodes; % ��ȡ��ɢ�ڵ�ļ���

for i=1:numel(dnodes)
    
    node = dnodes(i); % ��ǰ�ڵ�
    ps = bnet.parents{node}; % ��ǰ�ڵ�ĸ��ڵ�
    
    if isempty(ps) % Ϊ���ڵ�
        
        tmp = struct(bnet.CPD{node});
        count = zeros(2,1);
        
        count(1) = numel(find(cases(node,:)==1));
        count(2) = n_samples - count(1);
        
        p = (tmp.CPT.*tmp.dirichlet + count)/(dot(tmp.CPT,tmp.dirichlet) + n_samples);
        
        bnet.CPD{node} = cx_tabular_set_fields( bnet.CPD{node}, 'CPT', p, 'dirichlet', count);
        
    elseif numel(ps)==1 % ��һ�����ڵ�
        
        count = zeros(2,2);
        p = zeros(2,2);
        tmp = struct(bnet.CPD{node});
        
        tmpcase = cases([ps,node],:)';
        strcell = mat2cell(num2str(tmpcase), ones(1,n_samples), 4);
        % ͳ��11��12��21��22����������ֵ�Ƶ��
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

