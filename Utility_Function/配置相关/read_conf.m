function conf = read_conf(conf_path)

fid = fopen(conf_path, 'r');
conf = struct;

while ~feof(fid) % 判断是否为文件末尾   
    % 从文件读行并去掉行尾的空格
    tline = strtrim(fgetl(fid));
    if numel(tline)==0
        continue;
    end
    if tline(1)=='['
        key = tline(2:end-1);
        value = strtrim(fgetl(fid));
        conf = setfield(conf, key, value);
    end
end
fclose(fid);
