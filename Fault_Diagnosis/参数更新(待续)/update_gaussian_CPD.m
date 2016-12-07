function bnet = update_gaussian_CPD( bnet, cases )

% ----------------------------------------------------------------------- %
% �����˹�ڵ�a��2�����ڵ㣬�趨mean=[1 2 3 4]
% ��ʵ���ϲ鿴CPD.meanʱ:
% mean(:,1,1)=1
% mean(:,2,1)=2
% mean(:,1,2)=3
% mean(:,2,2)=4
% ���е�һλʼ��Ϊ:����������ֵ���ܸı䣬����2λ�����2�����ڵ��������
% �趨cov=[0.1 0.2 0.3 0.4]ʱ��CPD.covΪ��
% cov(:,:,1,1)=0.1
% cov(:,:,2,1)=0.2
% cov(:,:,1,2)=0.3
% cov(:,:,2,2)=0.4
% ��mean���ƣ�cov��ǰ2λҲ�ǹ̶�����ģ��鿴mean��covֵ��ʱ��Ҫע����һ�㣡
% ----------------------------------------------------------------------- %

n_samples = size(cases, 2);
cnodes = bnet.cnodes; % ��ȡ��˹�ڵ�ļ���

for i=1:numel(cnodes)
    
    node = cnodes(i); % ��ǰ�ڵ�
    ps = bnet.parents{node}; % ��ǰ�ڵ�ĸ��ڵ�
    nps = numel(ps);
    if nps==0 % û�и��ڵ㣬���Ȳ��������������޸��ڵ������壩
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % �õ���ǰ�ڵ��CPD
    tmp = struct(bnet.CPD{node});
    tmpcase = cases(ps,:)';
    strcell = mat2cell(num2str(tmpcase), ones(1,n_samples), 3*nps-2);
    % ����count��new_mean��new_cov ����
    if nps>1
        count = zeros(2*ones(1,nps)); 
    elseif nps==1
        count = [0;0];
    end
    new_mean = count;
    new_cov = count;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    switch nps % ���ݸ��ڵ�ĸ�����������
        
        case 1
            % =========================================================== %
            % ͳ��2��������ֵ�Ƶ��
            for ii=1:2
                flag = strncmp(strcell, num2str(ii), 3*nps-2);
                count(ii,1) = sum(flag);
                % �����еõ���������
                new_data = cases(node, flag);
                % ��p_count���棬������д
                p_count = bnet.gaussian_Pseudo_count{node}(ii);
                % ����α����
                bnet.gaussian_Pseudo_count{node}(ii) = count(ii) + p_count;
                % ��ֵ�ļ���Ϊ��ȷ���㣬��������Ϊ���Ƽ��㣬ֻ����Ϊ����
                new_mean(ii) = ( tmp.mean(:,ii)*p_count + sum(new_data) )/...
                    ( count(ii) + p_count );
                new_cov(ii) = ( tmp.cov(:,:,ii)*p_count + sum((new_data-tmp.mean(:,ii)).^2) )/...
                    ( count(ii) + p_count );
            end
            % =========================================================== %
            
        case 2
            % =========================================================== %
            % ͳ��4��������ֵ�Ƶ��
            for ii=1:2
                for jj=1:2
                    flag = strncmp(strcell, [num2str(ii),'  ',num2str(jj)], 3*nps-2);
                    count(ii,jj) = sum(flag);
                    % �����еõ���������
                    new_data = cases(node, flag);
                    % ��p_count���棬������д
                    p_count = bnet.gaussian_Pseudo_count{node}(ii,jj);
                    % ����α����
                    bnet.gaussian_Pseudo_count{node}(ii,jj) = count(ii,jj) + p_count;
                    % ��ֵ�ļ���Ϊ��ȷ���㣬��������Ϊ���Ƽ��㣬ֻ����Ϊ����
                    new_mean(ii,jj) = ( tmp.mean(:,ii,jj)*p_count + sum(new_data) )/...
                        ( count(ii,jj) + p_count );
                    new_cov(ii,jj) = ( tmp.cov(:,:,ii,jj)*p_count + sum((new_data-tmp.mean(:,ii,jj)).^2) )/...
                        ( count(ii,jj) + p_count );
                end
            end
            % =========================================================== %
            
        case 3
            % =========================================================== %
            % ͳ��8��������ֵ�Ƶ��
            for ii=1:2
                for jj=1:2
                    for kk=1:2
                        % flagΪ[ii,jj,kk]���ֵ�λ�� �߼�����
                        flag = strncmp(strcell, [num2str(ii),'  ',num2str(jj),'  ',num2str(kk)], 3*nps-2);
                        count(ii,jj,kk) = sum(flag); 
                        % �����еõ���������
                        new_data = cases(node, flag);
                        % ��p_count���棬������д
                        p_count = bnet.gaussian_Pseudo_count{node}(ii,jj,kk);
                        % ����α����
                        bnet.gaussian_Pseudo_count{node}(ii,jj,kk) = count(ii,jj,kk) + p_count;
                        % ��ֵ�ļ���Ϊ��ȷ���㣬��������Ϊ���Ƽ��㣬ֻ����Ϊ����
                        new_mean(ii,jj,kk) = ( tmp.mean(:,ii,jj,kk)*p_count + sum(new_data) )/...
                            ( count(ii,jj,kk) + p_count );
                        new_cov(ii,jj,kk) = ( tmp.cov(:,:,ii,jj,kk)*p_count + sum((new_data-tmp.mean(:,ii,jj,kk)).^2) )/...
                            ( count(ii,jj,kk) + p_count );
                    end
                end
            end
            % =========================================================== %
            
        case 4
            % =========================================================== %
            % ͳ��16��������ֵ�Ƶ��(��ûд��)
            for ii=1:2
                for jj=1:2
                    for kk=1:2
                        for mm=1:2
                            % flagΪ[ii,jj,kk]���ֵ�λ�� �߼�����
                            flag = strncmp(strcell, [num2str(ii),'  ',num2str(jj),'  ',num2str(kk),'  ',num2str(mm)], 3*nps-2);
                            count(ii,jj,kk,mm) = sum(flag); 
                            % �����еõ���������
                            new_data = cases(node, flag);
                            % ��p_count���棬������д
                            p_count = bnet.gaussian_Pseudo_count{node}(ii,jj,kk,mm);
                            % ����α����
                            bnet.gaussian_Pseudo_count{node}(ii,jj,kk,mm) = count(ii,jj,kk,mm) + p_count;
                            % ��ֵ�ļ���Ϊ��ȷ���㣬��������Ϊ���Ƽ��㣬ֻ����Ϊ����
                            new_mean(ii,jj,kk,mm) = ( tmp.mean(:,ii,jj,kk,mm)*p_count + sum(new_data) )/...
                                ( count(ii,jj,kk,mm) + p_count );
                            new_cov(ii,jj,kk,mm) = ( tmp.cov(:,:,ii,jj,kk,mm)*p_count + sum((new_data-tmp.mean(:,ii,jj,kk,mm)).^2) )/...
                            ( count(ii,jj,kk,mm) + p_count );
                        end
                    end
                end
            end
            % =========================================================== %
        otherwise
            errorlog(['���ڵ�Ϊ',num2str(nps),'���ĸ�˹�ڵ��CPD���»�û�б�д']);
    end
    
    if nps>1
        new_mean = reshape( new_mean, 1, 2^nps);
        new_cov = reshape( new_cov, 1, 2^nps);
    end
    
%     bnet.CPD{node} = gaussian_CPD(bnet, node, 'cov_type', 'diag', 'mean', new_mean, 'cov', new_cov );
    % ��gaussian_CPD������������������set mean��cov
    bnet.CPD{node} = cx_gaussian_set_fields(bnet.CPD{node}, 'mean', new_mean, 'cov', new_cov);
            
end

















        
        
        
        
        
        
        
        
    