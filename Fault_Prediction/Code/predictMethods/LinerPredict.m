function [ prediction delta ] = LinerPredict( train_data, train_fea, test_fea )

% �������

% noise = normrnd(0, 0.05, size(train_data));
[p s] = polyfit( train_fea, train_data, 1 );
% ��polyval�õ���biasֻ��50%�����Ŷ�����
% [ prediction, bias ] = polyval( pp, test_fea, s ); %

% polyconf ����95%��������
[ prediction, delta ] = polyconf(p, test_fea, s);
