% function my_updeta_CPD( bnet )

% ��������Ĳ������� %
tic;
N = size(bnet.dag, 1);
nsamples = 100;
cases = cell(N, nsamples);
for i=1:nsamples
    cases(:,i) = sample_bnet(bnet);
end
cases = cell2mat(cases);
toc;

tic; % �Լ���д�Ĳ��������㷨������α������
bnet1 = bnet;
bnet2 = bnet;
for i=1:nsamples
    bnet1 = update_gaussian_CPD( bnet1, cases(:,i) );
    bnet2 = update_tabular_CPD( bnet2, cases(:,i) );
end
toc;

tic; % ԭ�����ѧϰ�㷨���޷�����gaussian�����ٶ���
bnet3 = learn_params( bnet, cases);
toc;

mm = 488; % ����2�ߵ�����(mean���𲻴󣬵�cov�����ǽ��Ƽ��㣬��������)
s13 = struct(bnet1.CPD{mm});s13.mean,s13.cov
disp('-------------------');
s31 = struct(bnet3.CPD{mm});s31.mean,s31.cov

nn = 257; % ���շ��־������𲻴�
s23 = struct(bnet2.CPD{nn});s23.CPT
disp('-------------------');
s32 = struct(bnet3.CPD{nn});s32.CPT












