% function my_updeta_CPD( bnet )

% 基于先验的参数更新 %
tic;
N = size(bnet.dag, 1);
nsamples = 100;
cases = cell(N, nsamples);
for i=1:nsamples
    cases(:,i) = sample_bnet(bnet);
end
cases = cell2mat(cases);
toc;

tic; % 自己编写的参数更新算法（基于伪计数）
bnet1 = bnet;
bnet2 = bnet;
for i=1:nsamples
    bnet1 = update_gaussian_CPD( bnet1, cases(:,i) );
    bnet2 = update_tabular_CPD( bnet2, cases(:,i) );
end
toc;

tic; % 原版参数学习算法，无法更新gaussian，且速度慢
bnet3 = learn_params( bnet, cases);
toc;

mm = 488; % 测试2者的区别(mean区别不大，但cov由于是近似计算，误差较明显)
s13 = struct(bnet1.CPD{mm});s13.mean,s13.cov
disp('-------------------');
s31 = struct(bnet3.CPD{mm});s31.mean,s31.cov

nn = 257; % 最终发现精度区别不大
s23 = struct(bnet2.CPD{nn});s23.CPT
disp('-------------------');
s32 = struct(bnet3.CPD{nn});s32.CPT












