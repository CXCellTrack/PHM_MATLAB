function engine = AssignEngine( bnetCPD )

% ÿ�μ���engine��ʱ������10�����ң�ԭ�����engine�����mat�ٶ���
% ����Ϊexe����engineΪobject������struct����ȡ������
% ���ֻ��ÿ�ζ����¼��أ���bnetΪstruct�����Խ��б���

tic
engine = jtree_inf_engine(bnetCPD);
% writelog(['<��ʱ> ',num2str(toc), '��\n']);
writelog('toc',toc);

