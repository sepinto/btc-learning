addpath(genpath('.'))

%% Load
load 12022015.mat

%% Preprocess

[x, y] = raw2ready(txo_data);

%% Train
%svmModel = svm(x, y);
%[linRegModel, lrPredict] = trainLinReg(x,y);
% ... etc

%% Validate

%for lr
xlr = x; xlr(:,5:6) = [];
[lrTrain, lrTest] = trainLinReg('off');
kfoldValidation(10, xlr, y, lrTrain, lrTest);
