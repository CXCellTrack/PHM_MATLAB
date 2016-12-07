function [ info, NSM, all_name n_fault s_fault n_pipe n_sensor ] = buildNSM_by_xml( pipeclass )

% ��xml������bnt
diagpath = getphmpath('diag');
xmlpath = [diagpath, '\',pipeclass,'\data\udf\',pipeclass,'_info.xml'];
info = xml_read(xmlpath);


%% ���л�������ͳ��
n_sensor = numel(info.sensor);
n_pipe = 0;
% all_nameΪ������Ȼ�����<-��ʵ��ŵ��ֵ�
all_name = containers.Map('KeyType', 'char', 'ValueType', 'double');
for ii=1:n_sensor
    tmppipe = info.sensor(ii).pipe; % ��ǰsensor�µĵ�pipe
    if ~ischar( info.sensor(ii).ATTRIBUTE.name ) % �ı�sensor��nameΪchar�ͣ�������ڴ���
        info.sensor(ii).ATTRIBUTE.name = num2str(info.sensor(ii).ATTRIBUTE.name);
    end

    info.sensor(ii).pipeid = [];
    if ischar(tmppipe) % ���tmppipe��string�����װΪcell�����pipe�Զ�Ϊcell������pipeΪ�ַ�����
        tmppipe = {tmppipe};
    end 
    for jj=1:numel(tmppipe) 
        if ~all_name.isKey(tmppipe{jj})
            n_pipe = n_pipe+1; % ���ظ��Ļ����½�
            info.sensor(ii).pipeid = [info.sensor(ii).pipeid, n_pipe]; % pipeid��Ź�����Ȼ�����
            all_name(tmppipe{jj}) = n_pipe;
        else
            info.sensor(ii).pipeid = [info.sensor(ii).pipeid, all_name(tmppipe{jj})]; % pipeid��Ź�����Ȼ�����
        end
    end
end

%% ����nsm
FS = info.faultStructure;
s_fault = numel(FS.fault);
n_fault = s_fault*n_pipe;
n_node = n_fault + n_sensor; % �ܽڵ����
NSM = false(n_node, n_node); % ��Ҷ˹����ṹ

% -------------- �� faultStructure �Զ����ɵ����ߵ�nsm ------------------- %
singlenNSM = false(s_fault); % �����ߵĹ���nsm
for i=1:s_fault
    nextf = FS.fault(i).next;
    if ischar(nextf) % ���nextf��string�����װΪcell
        nextf = {nextf}; % Ϊ��ʵ��1���ڵ�ӵ��2���ӽڵ�����
    end
    for j=1:numel(nextf) % ����next�ڵ���ʣ�µĽ���ƥ��
        for k=i+1:s_fault
            if strcmp(FS.fault(k).ATTRIBUTE.name, nextf{j})
                singlenNSM(i,k) = true;
            end
        end
    end
end
% ---------------------------------------------------------------------- %    
            
for ii=1:s_fault:n_fault % ��singlenNSM����Ϊȫ��NSM
    NSM(ii:ii+s_fault-1,ii:ii+s_fault-1) = singlenNSM;
end
% ���Ӵ���������Ͻڵ�
for j=1:n_sensor
    thisid = info.sensor(j).pipeid;
    % ���ҵ��ô���������ĸ�����
    for i=1:s_fault
        if strcmp(FS.fault(i).ATTRIBUTE.sensorType, info.sensor(j).ATTRIBUTE.type)
            faulttype = i; % �����ϵ�sensorType�봫������typeƥ��
        end
    end
    for k=thisid
        rowid = (k-1)*s_fault + faulttype;
        colid = n_fault + j;
        NSM(rowid, colid) = true;
    end
end








