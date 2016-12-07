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
        errorlog('����getphmpath���������Υ����');
end

% ��Ҫ��PHM_HOME����Ϊϵͳ��������

if ~status
    cmdans = strsplit('=', result);
    path = mydeblank( cell2mat(cmdans(2)) );
else
    errorlog(['û���ҵ��������� ',pathname]);
end















