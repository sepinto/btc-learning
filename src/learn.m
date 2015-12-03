clear all
addpath('preprocess'); addpath('data');

load 11302015.mat
% Our data is a cell array of structures. Need to convert to a matrix.
trnx = btc_data2mat(x);
trny = y';
C = max(trny) - min(trny);

clear x, clear y
% model = svmtrain(trny, trnx, ['-s 3 -t 0 -c ', num2str(C)]);



