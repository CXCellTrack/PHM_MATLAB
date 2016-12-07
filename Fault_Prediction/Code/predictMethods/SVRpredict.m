function [ prediction bias ] = SVRpredict( train_data, train_fea, test_fea, cmd )

% cmd�в�����ϵ��pҪСһ��
% ��ʼѵ��
model = svmtrain(train_data', train_fea', cmd); % ��-b1����ʾ������˹�ֲ� model.ProbA����������˹��sigma

% Ԥ����
prediction = svmpredict(test_fea', test_fea', model, '-b 0 -q');

u = 0; % ��ֵΪ0
p = 0.975; % 95%��������
bias = u - model.ProbA*sign(p-0.5)*log(1-2*abs(p-0.5)); % ����Ԥ��ֵ��95%��������Ϊ[value-bias, value+bias]







