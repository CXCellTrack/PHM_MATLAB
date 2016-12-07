function WriteData2txt( txtname, data2write )
% 
% 将data2write这个cell中的内容保存在本地的数据库中
txtname = alterPath(txtname);
writelog(['将数据备份到本地',txtname,'中...\n']);

fid = fopen(txtname, 'wt');
if fid==-1
    errorlog(['创建',txtname,'失败！']);
end

[ h, w ] = size(data2write);
for i=1:h
    for j=1:w-1 % 后面打印数据
        fprintf(fid, '%s,', data2write{i,j});
    end
    j = w;
    fprintf(fid, '%s\n', data2write{i,j});
end
fclose(fid);

writelog('数据备份完成！\n\n');

end

