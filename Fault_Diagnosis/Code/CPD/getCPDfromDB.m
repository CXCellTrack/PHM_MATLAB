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

% ����ǰ��CPDֵд��һ��txt�� % 2016.4.7 ����xml��
% current_CPD_path = [diagpath, '\',pipeclass,'\data\udf\current_CPD_',pipeclass,'.txt'];
% ----------------------------------------------------------------------- %
% ����ͳ�Ʊ� ST_tablename��CPD�ĳ�ֵ��Ҫ��ͳ�Ʊ��ж���
ST_table_path = [diagpath, '\', pipeclass, '\data\sql\', ST_tablename, '.sql'];
execute_sql_script(ST_table_path);

% У��ͳ�Ʊ��Ƿ񴴽��ɹ������û��ֱ�ӱ���
validateTable(conn, ST_tablename);
% ----------------------------------------------------------------------- %
% fidout = fopen(current_CPD_path,'wt');

tm = datestr(now,31);
% fprintf(fidout, ['<����ʱ��>',tm,'\n�˱��ŵ��Ǹ�ʱ�̴����ݿ��м���õ���CPD\n\n']);
        
for h=1:numel(info.sensor)
    sensorname = info.sensor(h).ATTRIBUTE.name;
%     if ~ischar(sensorname) % sensorname����Ǵ����ֻᱻ�������֣���Ҫת��char
%         sensorname = num2str(sensorname); % �ڶ���ʱ�Ѿ�����ת��
%     end   
    sql = sprintf('select "count","mean","cov" from %s where DEVCODE=''%s''', ...
        ST_tablename, sensorname);
    DATA = fetch_data(conn, sql);
    % ��ѯ�����������һ����Ҫ�����ݵĸ�����50���ϲ�ͳ�ƣ�
    if strcmp(DATA{1},'No Data') || DATA{1}<50
        continue
    end
    
    % �õ��ֶ���д��mean��cov����
    sid = n_fault + h;
    origin = struct(bnet1.CPD{sid});
    
    % ����������ɢ�ֱ����cpd
    if bnet1.node_sizes(sid)==1
        origin.Mean = reshape(origin.mean,1,[]);
        origin.Cov = reshape(origin.cov,1,[]);
        
        % �����ݿ��е�ͳ����Ϊ�޹���ʱ��CPD����
        newMean = [DATA{2}, origin.Mean(2:end)];
%         newCov = [DATA{3}, origin.Cov(2:end)]; 
        newCov = repmat(DATA{3}, 1, length(origin.Cov)); % 2016.12.2�����еķ���ĵĺ��޹���ʱ��ͬ
        newCov(newCov==0) = 0.1;
        
        info.sensor(h).CPD.mean = newMean;
        info.sensor(h).CPD.cov = newCov;
        % -- ��������CPD����current txt�У��Թ���ѯ -- %
%         nM = num2strcell(newMean,'%.0f'); nM = cellfun(@(x) [x,','],nM,'un',0); nM = cell2mat(nM);
%         nC = num2strcell(newCov,'%.2f'); nC = cellfun(@(x) [x,','],nC,'un',0); nC = cell2mat(nC);     
%         lines = [sensorname,'\t: ',nM(1:end-1), ': ',nC(1:end-1),'\n\n'];
%         fprintf(fidout, lines);
        % ------------------------------------------ %
        
        bnet1.CPD{sid} = gaussian_CPD(bnet1, sid, 'cov_type', 'diag',...
                        'mean', newMean, 'cov', newCov ); % ���贫��������Ϊ��˹�ֲ�
                    
    elseif bnet1.node_sizes(sid)==2
        origin.CPD = reshape(origin.CPT, 1, []);
        newCPD = [DATA{2}, origin.CPD(2:end)];
        
        info.sensor(h).CPD = newCPD;
        % -- ��������CPD����current txt�У��Թ���ѯ -- %
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
Pref = struct; Pref.CellItem = false; Pref.StructItem = false; % ����xml������
info.ATTRIBUTE.time = tm;
xml_write(xmlpath, info, 'current_Water_info', Pref);








