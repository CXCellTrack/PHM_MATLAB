clear

% 连接数据库
conn = link_Oracle_Database;

pipeclass = 'Water';
% ----------------------------------------------------------------------- %
% 读入原始D矩阵数据 传感器使用cad编号 管线使用简单数字代号（有冲突！）
diagpath = getphmpath('diag');
Dmatrix_raw_path = [diagpath, '\',pipeclass,'\data\udf\Dmatrix_',pipeclass,'_raw.txt'];
Dmatrix_raw = read_Dmatrix( Dmatrix_raw_path );
flag = ~isemptycell(Dmatrix_raw);
% 写入目标：标准D矩阵
Dmatrix_path = [diagpath, '\',pipeclass,'\data\udf\Dmatrix_',pipeclass,'.txt'];
fidin = fopen( Dmatrix_path, 'wt');
% ----------------------------------------------------------------------- %


% ----------------------------------------------------------------------- %
for h=1:size(Dmatrix_raw,1)
    
    % 从传感器表中读入传感器数字编号，取代cad编号
    cadNUM = Dmatrix_raw{h,1}; % 新的行
    sql = ['select "编号" from "传感器" where "CAD编号"=''',cadNUM,''''];
    DATA = fetch_data(conn, sql);
    assert(numel(DATA)==1); % 断言管线编号没有重复
    newline = DATA{1};
    
    for w=2:size(Dmatrix_raw,2)
        if ~flag(h,w)
            continue
        end
        group = strsplit(',', Dmatrix_raw{h,w});
        newzu = [];
        for pp=group
            pp = mydeblank(pp);
            % 目前水管只在大区域，而左下角吴中集团的水管带有LGL字样，先不查询
            if strncmp(cadNUM,'JS_DMA1',7)
                sql = ['select "Handle" from "给水管线_polyline" where instr("Handle",''',pp{1},''')>0 and instr("Handle",''LGL'')=0'];
            elseif strncmp(cadNUM,'JS_DMA2',7) % DMA2区域的管线都带有LGL字样
                sql = ['select "Handle" from "给水管线_polyline" where instr("Handle",''',pp{1},''')>0 and instr("Handle",''LGL'')>0'];
            else
                error('不是DMA1也不是DMA2！');
            end
            DATA = fetch_data(conn, sql);
            assert(numel(DATA)==1 & ~strcmp(DATA{1},'No Data')); % 断言管线编号没有重复，且都有数据
            newzu = [newzu, ',', DATA{1}];
        end
        Dmatrix_raw{h,w} = newzu(2:end); % 将Dmatrix中的数字全变成管线全名
        
        newline = [newline,'\t:', Dmatrix_raw{h,w}];
    end
    fprintf(fidin, [newline,'\n\n']); % 输出新的行
end
fclose(fidin);
close(conn)
        
        
        
        
        
        
        
        
        
            
