function [ prediction delta ] = LinerPredict( train_data, train_fea, test_fea )

% 线性拟合

% noise = normrnd(0, 0.05, size(train_data));
[p s] = polyfit( train_fea, train_data, 1 );
% 用polyval得到的bias只是50%的置信度区间
% [ prediction, bias ] = polyval( pp, test_fea, s ); %

% polyconf 给出95%置信区间
[ prediction, delta ] = polyconf(p, test_fea, s);
