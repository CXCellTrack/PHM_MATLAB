function bnet1 = getCPDfromDB( conn, bnet1, info, pipeclass, diagpath, n_fault )

switch pipeclass 
    case 'Water'
        ST_tablename = 'ST_AD_SL_NOISE';
    case 'Sewage'
        ST_tablename = 'ST_AD_DJ_LIQUID';
    case 'Rain'
        ST_tablename = 'ST_AD_DJ_LIQUID';
    case 'Gas'
        ST_tablename = '';
    case 'Heat'
        ST_tablename = '';     
end

% 将当前的CPD值写入一个txt中 % 2016.4.7 改用xml了
% current_CPD_path = [diagpath, '\',pipeclass,'\data\udf\current_CPD_',pipeclass,'.txt'];
% ----------------------------------------------------------------------- %
% 创建统计表 ST_tablename，CPD的初值需要从统计表中读入
ST_table_path = [diagpath, '\', pipeclass, '\data\sql\', ST_tablename, '.sql'];
execute_sql_script(ST_table_path);

% 校验统计表是否创建成功，如果没有直接报错。
validateTable(conn, ST_tablename);
% ----------------------------------------------------------------------- %
% fidout = fopen(current_CPD_path,'wt');

tm = datestr(now,31);
% fprintf(fidout, ['<生成时间>',tm,'\n此表存放的是该时刻从数据库中计算得到的CPD\n\n']);
        
for h=1:numel(info.sensor)
    sensorname = info.sensor(h).ATTRIBUTE.name;
%     if ~ischar(sensorname) % sensorname如果是纯数字会被读成数字，需要转成char
%         sensorname = num2str(sensorname); % 在读入时已经做了转换
%     end   
    sql = sprintf('select "count","mean","cov" from %s where DEVCODE=''%s''', ...
        ST_tablename, sensorname);
    DATA = fetch_data(conn, sql);
    % 查询不到则进入下一个（要求数据的个数在50以上才统计）
    if strcmp(DATA{1},'No Data') || DATA{1}<50
        continue
    end
    
    % 得到手动填写的mean和cov数据
    sid = n_fault + h;
    origin = struct(bnet1.CPD{sid});
    
    % 按连续，离散分别更新cpd
    if bnet1.node_sizes(sid)==1
        origin.Mean = reshape(origin.mean,1,[]);
        origin.Cov = reshape(origin.cov,1,[]);
        
        % 将数据库中的统计作为无故障时的CPD数据
        newMean = [DATA{2}, origin.Mean(2:end)];
%         newCov = [DATA{3}, origin.Cov(2:end)]; 
        newCov = repmat(DATA{3}, 1, length(origin.Cov)); % 2016.12.2将所有的方差改的和无故障时相同
        newCov(newCov==0) = 0.1;
        
        info.sensor(h).CPD.mean = newMean;
        info.sensor(h).CPD.cov = newCov;
        % -- 将读到的CPD存入current txt中，以供查询 -- %
%         nM = num2strcell(newMean,'%.0f'); nM = cellfun(@(x) [x,','],nM,'un',0); nM = cell2mat(nM);
%         nC = num2strcell(newCov,'%.2f'); nC = cellfun(@(x) [x,','],nC,'un',0); nC = cell2mat(nC);     
%         lines = [sensorname,'\t: ',nM(1:end-1), ': ',nC(1:end-1),'\n\n'];
%         fprintf(fidout, lines);
        % ------------------------------------------ %
        
        bnet1.CPD{sid} = gaussian_CPD(bnet1, sid, 'cov_type', 'diag',...
                        'mean', newMean, 'cov', newCov ); % 假设传感器数据为高斯分布
                    
    elseif bnet1.node_sizes(sid)==2
        origin.CPD = reshape(origin.CPT, 1, []);
        newCPD = [DATA{2}, origin.CPD(2:end)];
        
        info.sensor(h).CPD = newCPD;
        % -- 将读到的CPD存入current txt中，以供查询 -- %
%         nM = num2strcell(newCPD,'%.0f'); nM = cellfun(@(x) [x,','],nM,'un',0); nM = cell2mat(nM);  
%         lines = [sensorname,'\t: ',nM(1:end-1),'\n\n'];
%         fprintf(fidout, lines);
        % ------------------------------------------ %
        
        bnet1.CPD{sid} = tabular_CPD(bnet1, sid, 'CPT', newCPD,...
            'prior_type', 'dirichlet', 'dirichlet_type', 'unif', 'dirichlet_weight', DATA{1});
    end

end

% fclose(fidout);

xmlpath = [diagpath, '\',pipeclass,'\data\udf\current_',pipeclass,'_info.xml'];
Pref = struct; Pref.CellItem = false; Pref.StructItem = false; % 控制xml的特性
info.ATTRIBUTE.time = tm;
xml_write(xmlpath, info, 'current_Water_info', Pref);








