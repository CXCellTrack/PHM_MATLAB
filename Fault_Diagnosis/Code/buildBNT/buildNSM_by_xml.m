function [ info, NSM, all_name n_fault s_fault n_pipe n_sensor ] = buildNSM_by_xml( pipeclass )

% 由xml来创建bnt
diagpath = getphmpath('diag');
xmlpath = [diagpath, '\',pipeclass,'\data\udf\',pipeclass,'_info.xml'];
info = xml_read(xmlpath);


%% 进行基础数据统计
n_sensor = numel(info.sensor);
n_pipe = 0;
% all_name为管线自然数编号<-真实编号的字典
all_name = containers.Map('KeyType', 'char', 'ValueType', 'double');
for ii=1:n_sensor
    tmppipe = info.sensor(ii).pipe; % 当前sensor下的的pipe
    if ~ischar( info.sensor(ii).ATTRIBUTE.name ) % 改变sensor的name为char型，方便后期处理
        info.sensor(ii).ATTRIBUTE.name = num2str(info.sensor(ii).ATTRIBUTE.name);
    end

    info.sensor(ii).pipeid = [];
    if ischar(tmppipe) % 如果tmppipe是string，则封装为cell（多个pipe自动为cell，单个pipe为字符串）
        tmppipe = {tmppipe};
    end 
    for jj=1:numel(tmppipe) 
        if ~all_name.isKey(tmppipe{jj})
            n_pipe = n_pipe+1; % 不重复的话则新建
            info.sensor(ii).pipeid = [info.sensor(ii).pipeid, n_pipe]; % pipeid存放管线自然数编号
            all_name(tmppipe{jj}) = n_pipe;
        else
            info.sensor(ii).pipeid = [info.sensor(ii).pipeid, all_name(tmppipe{jj})]; % pipeid存放管线自然数编号
        end
    end
end

%% 建立nsm
FS = info.faultStructure;
s_fault = numel(FS.fault);
n_fault = s_fault*n_pipe;
n_node = n_fault + n_sensor; % 总节点个数
NSM = false(n_node, n_node); % 贝叶斯网络结构

% -------------- 由 faultStructure 自动生成单管线的nsm ------------------- %
singlenNSM = false(s_fault); % 单管线的故障nsm
for i=1:s_fault
    nextf = FS.fault(i).next;
    if ischar(nextf) % 如果nextf是string，则封装为cell
        nextf = {nextf}; % 为了实现1个节点拥有2个子节点的情况
    end
    for j=1:numel(nextf) % 将其next节点与剩下的进行匹配
        for k=i+1:s_fault
            if strcmp(FS.fault(k).ATTRIBUTE.name, nextf{j})
                singlenNSM(i,k) = true;
            end
        end
    end
end
% ---------------------------------------------------------------------- %    
            
for ii=1:s_fault:n_fault % 将singlenNSM复制为全体NSM
    NSM(ii:ii+s_fault-1,ii:ii+s_fault-1) = singlenNSM;
end
% 连接传感器与故障节点
for j=1:n_sensor
    thisid = info.sensor(j).pipeid;
    % 先找到该传感器监控哪个故障
    for i=1:s_fault
        if strcmp(FS.fault(i).ATTRIBUTE.sensorType, info.sensor(j).ATTRIBUTE.type)
            faulttype = i; % 将故障的sensorType与传感器的type匹配
        end
    end
    for k=thisid
        rowid = (k-1)*s_fault + faulttype;
        colid = n_fault + j;
        NSM(rowid, colid) = true;
    end
end








