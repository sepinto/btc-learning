addpath(genpath('.'))

%% Load
load 12022015.mat

%% Preprocess
[x, y] = raw2ready(txo_data);

%% Cluster and Fit Distribution
% pdf = fitDistribution(y, 4); % pdf is a function handle
[pdf, idx, phi, pdfs] = fitDistribution(y, 2, 'diagnostics', 1);
plotCluster(y, pdf, idx, phi, pdfs, [1 2 3]);

%% Define l equal-probability subdomains
% labels = label(y, pdf, 10);
numClasses = 5;
[labels, domain, cdf, edges] = label(y,pdf,numClasses,'diagnostics',1);
plotSubdomains(y, labels, domain, cdf, edges, [4 5]);

%% Train
%svmModel = svm(x, y);
%[linRegModel, lrPredict] = trainLinReg(x,y);
% ... etc

%% Validate

xlr = x; xlr(:,5:6) = [];
[mnTrain, mnPred] = mnMdl(numClasses);
[svmTrain, svmPred] = svm();

mdlsTrain = {mnTrain ; svmTrain};
mdlsPred  = {mnPred  ; svmPred};
mdlsTrain = {svmTrain};
mdlsPred  = {svmPred};

mdlsName = {'multinomial', 'svm'};

[ptest ptrain] = kfoldValidation(5, full(xlr), labels, mdlsTrain, mdlsPred);