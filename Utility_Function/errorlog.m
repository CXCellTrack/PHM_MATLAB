function errorlog( event )

% ��������ļ���ʹ��checklog���Կ��ٽ��У������ȵ�ʱ�����
fid = fopen([getphmpath('home'), '\Csharp����\done.flag'], 'w+');
fclose(fid);

fu = '-------------------------------------------------\n';
event = [ fu,'<�����쳣> ',event,'\n',fu ];
writelog( event, 1 );
error(event);
