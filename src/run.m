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
[labels, domain, cdf, edges] = label(y,pdf,10,'diagnostics',1);
plotSubdomains(y, labels, domain, cdf, edges, [4 5]);

%% Train
%svmModel = svm(x, y);
%[linRegModel, lrPredict] = trainLinReg(x,y);
% ... etc

%% Validate

classEdges = [0 50 200 500 inf];
numClasses = size(classEdges,2)-1;
ydisc = discretize(y, classEdges);
xlr = x; xlr(:,5:6) = [];
[lrTrain, lrTest] = trainLinReg('off');
[mnTrain, mnPred] = mnMdl(numClasses);
p = kfoldValidation(10, xlr, ydisc, mnTrain, mnPred);