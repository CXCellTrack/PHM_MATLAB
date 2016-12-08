function errorlog( event )

% 创建标记文件，使得checklog得以快速进行，否则会等到时间耗完
fid = fopen([getphmpath('home'), '\Csharp代码\done.flag'], 'w+');
fclose(fid);

fu = '-------------------------------------------------\n';
event = [ fu,'<出现异常> ',event,'\n',fu ];
writelog( event, 1 );
error(event);
