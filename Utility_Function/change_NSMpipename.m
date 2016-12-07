clear

% �������ݿ�
conn = link_Oracle_Database;

pipeclass = 'Water';
% ----------------------------------------------------------------------- %
% ����ԭʼD�������� ������ʹ��cad��� ����ʹ�ü����ִ��ţ��г�ͻ����
diagpath = getphmpath('diag');
Dmatrix_raw_path = [diagpath, '\',pipeclass,'\data\udf\Dmatrix_',pipeclass,'_raw.txt'];
Dmatrix_raw = read_Dmatrix( Dmatrix_raw_path );
flag = ~isemptycell(Dmatrix_raw);
% д��Ŀ�꣺��׼D����
Dmatrix_path = [diagpath, '\',pipeclass,'\data\udf\Dmatrix_',pipeclass,'.txt'];
fidin = fopen( Dmatrix_path, 'wt');
% ----------------------------------------------------------------------- %


% ----------------------------------------------------------------------- %
for h=1:size(Dmatrix_raw,1)
    
    % �Ӵ��������ж��봫�������ֱ�ţ�ȡ��cad���
    cadNUM = Dmatrix_raw{h,1}; % �µ���
    sql = ['select "���" from "������" where "CAD���"=''',cadNUM,''''];
    DATA = fetch_data(conn, sql);
    assert(numel(DATA)==1); % ���Թ��߱��û���ظ�
    newline = DATA{1};
    
    for w=2:size(Dmatrix_raw,2)
        if ~flag(h,w)
            continue
        end
        group = strsplit(',', Dmatrix_raw{h,w});
        newzu = [];
        for pp=group
            pp = mydeblank(pp);
            % Ŀǰˮ��ֻ�ڴ����򣬶����½����м��ŵ�ˮ�ܴ���LGL�������Ȳ���ѯ
            if strncmp(cadNUM,'JS_DMA1',7)
                sql = ['select "Handle" from "��ˮ����_polyline" where instr("Handle",''',pp{1},''')>0 and instr("Handle",''LGL'')=0'];
            elseif strncmp(cadNUM,'JS_DMA2',7) % DMA2����Ĺ��߶�����LGL����
                sql = ['select "Handle" from "��ˮ����_polyline" where instr("Handle",''',pp{1},''')>0 and instr("Handle",''LGL'')>0'];
            else
                error('����DMA1Ҳ����DMA2��');
            end
            DATA = fetch_data(conn, sql);
            assert(numel(DATA)==1 & ~strcmp(DATA{1},'No Data')); % ���Թ��߱��û���ظ����Ҷ�������
            newzu = [newzu, ',', DATA{1}];
        end
        Dmatrix_raw{h,w} = newzu(2:end); % ��Dmatrix�е�����ȫ��ɹ���ȫ��
        
        newline = [newline,'\t:', Dmatrix_raw{h,w}];
    end
    fprintf(fidin, [newline,'\n\n']); % ����µ���
end
fclose(fidin);
close(conn)
        
        
        
        
        
        
        
        
        
            
