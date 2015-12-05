addpath('data'); addpath('preprocess'); addpath('train');
addpath('validation');

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
classEdges = [0 50 200 500 inf];
numClasses = size(classEdges,2)-1;
ydisc = discretize(y, classEdges);
xlr = x; xlr(:,5:6) = [];
[lrTrain, lrTest] = trainLinReg('off');
[mnTrain, mnPred] = mnMdl(numClasses);
p = kfoldValidation(10, xlr, ydisc, mnTrain, mnPred);
