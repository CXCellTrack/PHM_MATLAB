function WriteData2txt( txtname, data2write )
% 
% ��data2write���cell�е����ݱ����ڱ��ص����ݿ���
txtname = alterPath(txtname);
writelog(['�����ݱ��ݵ�����',txtname,'��...\n']);

fid = fopen(txtname, 'wt');
if fid==-1
    errorlog(['����',txtname,'ʧ�ܣ�']);
end

[ h, w ] = size(data2write);
for i=1:h
    for j=1:w-1 % �����ӡ����
        fprintf(fid, '%s,', data2write{i,j});
    end
    j = w;
    fprintf(fid, '%s\n', data2write{i,j});
end
fclose(fid);

writelog('���ݱ�����ɣ�\n\n');

end

