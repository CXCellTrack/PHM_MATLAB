function [ prediction bias ] = SVRpredict( train_data, train_fea, test_fea, cmd )

% cmd中不敏感系数p要小一点
% 开始训练
model = svmtrain(train_data', train_fea', cmd); % 加-b1会显示拉普拉斯分布 model.ProbA就是拉普拉斯的sigma

% 预测结果
prediction = svmpredict(test_fea', test_fea', model, '-b 0 -q');

u = 0; % 均值为0
p = 0.975; % 95%置信区间
bias = u - model.ProbA*sign(p-0.5)*log(1-2*abs(p-0.5)); % 最终预测值的95%置信区间为[value-bias, value+bias]







