addpath('preprocess'); addpath('data');

load new_data
% Our data is a cell array of structures. Need to convert to a matrix.
[trnx, trny] = btc_data2mat(txo_data);
C = max(trny) - min(trny);
clear txo_data

model = svmtrain(trny, trnx, ['-s 3 -t 0 -c ', num2str(C), ' -h 0']);



