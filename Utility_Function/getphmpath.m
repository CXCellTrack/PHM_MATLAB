function path = getphmpath( pathname )

switch pathname
    case 'home'
        [status, result] = system('set PHM_HOME'); 
    case 'diag'
        [status, result] = system('set diagpath'); 
    case 'predict'
        [status, result] = system('set predictpath'); 
    case 'eval'
        [status, result] = system('set evalpath'); 
    case 'rul'
        [status, result] = system('set rulpath'); 
    otherwise
        errorlog('函数getphmpath的输入参数违法！');
end

% 需要将PHM_HOME设置为系统环境变量

if ~status
    cmdans = strsplit('=', result);
    path = mydeblank( cell2mat(cmdans(2)) );
else
    errorlog(['没有找到环境变量 ',pathname]);
end















