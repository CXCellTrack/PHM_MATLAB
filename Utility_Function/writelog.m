function writelog( event, addtime, mode )
% 
% ������������exe�����н��д��log��
% ������windows�����н��д�����
% 
% addtimeΪ0��1������ָʾ�Ƿ����ʱ��
% ----------------------------------------------------------------------- %

% ����һ�������÷���event��д'toc'��addtime��дtoc���������ʱ��(tic,toc)
% ʾ����writelog('toc',toc);
if nargin==2 && strcmp(event,'toc')==1  
    writelog(['<��ʱ> ',num2str(addtime),'��\n']); % ������������
    return;
end

% ----------------------------------------------------------------------- %
if nargin==1
    addtime = 0;
    mode = 'append';
elseif nargin==2 % mode��ָ���Ļ�Ĭ��Ϊ1
    mode = 'append';
end
switch mode
    case 'rewrite'
        mode = 'wt';
    case 'append'
        mode = 'at';
    otherwise
        error('��־�ļ�����ģʽֻ��Ϊ rewrite �� append');
end

home = getphmpath('home');
fid = fopen([home, '\Csharp����\PHM.log'], mode);
if fid==-1
    error('��log�ļ�ʧ�ܣ�');
end

% ----------------------------------------------------------------------- %
% ��ǰʱ������Ϊ�ַ�����ʽ
% nowtime = [num2str(year(now)),'/',num2str(month(now)),'/',num2str(day(now)),...
%     ' ',num2str(hour(now)),':',num2str(minute(now)),':',num2str(fix(second(now)))];
nowtime = datestr(now,31);
% ʹ��addtime��ָʾ�Ƿ����ʱ���
if addtime
    event = ['<ʱ��> ',nowtime,'\n', event];
end
fprintf(fid, event); % ����Ϣд��log��
fclose(fid);

% ----------------------------------------------------------------------- %
% �ڿ���̨��ӡ�£�����matlab����
fprintf(event);


        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
