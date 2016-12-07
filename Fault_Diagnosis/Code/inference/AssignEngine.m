function engine = AssignEngine( bnetCPD )

% 每次加载engine的时间大概在10秒左右，原来想把engine保存成mat再读入
% 编译为exe后发现engine为object而不是struct，读取有问题
% 因此只能每次都重新加载，但bnet为struct，可以进行保存

tic
engine = jtree_inf_engine(bnetCPD);
% writelog(['<耗时> ',num2str(toc), '秒\n']);
writelog('toc',toc);

