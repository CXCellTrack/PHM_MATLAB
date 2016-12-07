function bnet = update_gaussian_CPD( bnet, cases )

% ----------------------------------------------------------------------- %
% 比如高斯节点a有2个父节点，设定mean=[1 2 3 4]
% 则实际上查看CPD.mean时:
% mean(:,1,1)=1
% mean(:,2,1)=2
% mean(:,1,2)=3
% mean(:,2,2)=4
% 其中第一位始终为:，代表连续值不能改变，后面2位则代表2个父节点的组合情况
% 设定cov=[0.1 0.2 0.3 0.4]时，CPD.cov为：
% cov(:,:,1,1)=0.1
% cov(:,:,2,1)=0.2
% cov(:,:,1,2)=0.3
% cov(:,:,2,2)=0.4
% 与mean类似，cov的前2位也是固定不变的，查看mean和cov值的时候要注意这一点！
% ----------------------------------------------------------------------- %

n_samples = size(cases, 2);
cnodes = bnet.cnodes; % 获取高斯节点的集合

for i=1:numel(cnodes)
    
    node = cnodes(i); % 当前节点
    ps = bnet.parents{node}; % 当前节点的父节点
    nps = numel(ps);
    if nps==0 % 没有父节点，则先不做处理（传感器无父节点无意义）
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % 得到当前节点的CPD
    tmp = struct(bnet.CPD{node});
    tmpcase = cases(ps,:)';
    strcell = mat2cell(num2str(tmpcase), ones(1,n_samples), 3*nps-2);
    % 建立count、new_mean、new_cov 矩阵
    if nps>1
        count = zeros(2*ones(1,nps)); 
    elseif nps==1
        count = [0;0];
    end
    new_mean = count;
    new_cov = count;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    switch nps % 根据父节点的个数进行区别
        
        case 1
            % =========================================================== %
            % 统计2种情况出现的频率
            for ii=1:2
                flag = strncmp(strcell, num2str(ii), 3*nps-2);
                count(ii,1) = sum(flag);
                % 样本中得到的新数据
                new_data = cases(node, flag);
                % 用p_count代替，便于书写
                p_count = bnet.gaussian_Pseudo_count{node}(ii);
                % 更新伪计数
                bnet.gaussian_Pseudo_count{node}(ii) = count(ii) + p_count;
                % 均值的计算为精确计算，而方差则为近似计算，只能作为估计
                new_mean(ii) = ( tmp.mean(:,ii)*p_count + sum(new_data) )/...
                    ( count(ii) + p_count );
                new_cov(ii) = ( tmp.cov(:,:,ii)*p_count + sum((new_data-tmp.mean(:,ii)).^2) )/...
                    ( count(ii) + p_count );
            end
            % =========================================================== %
            
        case 2
            % =========================================================== %
            % 统计4种情况出现的频率
            for ii=1:2
                for jj=1:2
                    flag = strncmp(strcell, [num2str(ii),'  ',num2str(jj)], 3*nps-2);
                    count(ii,jj) = sum(flag);
                    % 样本中得到的新数据
                    new_data = cases(node, flag);
                    % 用p_count代替，便于书写
                    p_count = bnet.gaussian_Pseudo_count{node}(ii,jj);
                    % 更新伪计数
                    bnet.gaussian_Pseudo_count{node}(ii,jj) = count(ii,jj) + p_count;
                    % 均值的计算为精确计算，而方差则为近似计算，只能作为估计
                    new_mean(ii,jj) = ( tmp.mean(:,ii,jj)*p_count + sum(new_data) )/...
                        ( count(ii,jj) + p_count );
                    new_cov(ii,jj) = ( tmp.cov(:,:,ii,jj)*p_count + sum((new_data-tmp.mean(:,ii,jj)).^2) )/...
                        ( count(ii,jj) + p_count );
                end
            end
            % =========================================================== %
            
        case 3
            % =========================================================== %
            % 统计8种情况出现的频率
            for ii=1:2
                for jj=1:2
                    for kk=1:2
                        % flag为[ii,jj,kk]出现的位置 逻辑矩阵
                        flag = strncmp(strcell, [num2str(ii),'  ',num2str(jj),'  ',num2str(kk)], 3*nps-2);
                        count(ii,jj,kk) = sum(flag); 
                        % 样本中得到的新数据
                        new_data = cases(node, flag);
                        % 用p_count代替，便于书写
                        p_count = bnet.gaussian_Pseudo_count{node}(ii,jj,kk);
                        % 更新伪计数
                        bnet.gaussian_Pseudo_count{node}(ii,jj,kk) = count(ii,jj,kk) + p_count;
                        % 均值的计算为精确计算，而方差则为近似计算，只能作为估计
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
            % 统计16种情况出现的频率(还没写完)
            for ii=1:2
                for jj=1:2
                    for kk=1:2
                        for mm=1:2
                            % flag为[ii,jj,kk]出现的位置 逻辑矩阵
                            flag = strncmp(strcell, [num2str(ii),'  ',num2str(jj),'  ',num2str(kk),'  ',num2str(mm)], 3*nps-2);
                            count(ii,jj,kk,mm) = sum(flag); 
                            % 样本中得到的新数据
                            new_data = cases(node, flag);
                            % 用p_count代替，便于书写
                            p_count = bnet.gaussian_Pseudo_count{node}(ii,jj,kk,mm);
                            % 更新伪计数
                            bnet.gaussian_Pseudo_count{node}(ii,jj,kk,mm) = count(ii,jj,kk,mm) + p_count;
                            % 均值的计算为精确计算，而方差则为近似计算，只能作为估计
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
            errorlog(['父节点为',num2str(nps),'个的高斯节点的CPD更新还没有编写']);
    end
    
    if nps>1
        new_mean = reshape( new_mean, 1, 2^nps);
        new_cov = reshape( new_cov, 1, 2^nps);
    end
    
%     bnet.CPD{node} = gaussian_CPD(bnet, node, 'cov_type', 'diag', 'mean', new_mean, 'cov', new_cov );
    % 在gaussian_CPD类中新增函数，用于set mean和cov
    bnet.CPD{node} = cx_gaussian_set_fields(bnet.CPD{node}, 'mean', new_mean, 'cov', new_cov);
            
end

















        
        
        
        
        
        
        
        
    