addpath(genpath('.'))

%% Load
load 12022015.mat

%% Preprocess
[x, y] = raw2ready(txo_data);

%% Cluster and Fit Distribution
pdf = fitDistribution(data, k); % pdf is a function handle

%% Define k equal-probability ranges
granularity = 1e5;
domain = linspace(min(y),max(y),granularity);

%% Train
%svmModel = svm(x, y);
%[linRegModel, lrPredict] = trainLinReg(x,y);
% ... etc

%% Validate

%for lr
xlr = x; xlr(:,5:6) = [];
[lrTrain, lrTest] = trainLinReg('off');
kfoldValidation(10, xlr, y, lrTrain, lrTest);
