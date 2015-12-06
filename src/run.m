addpath(genpath('.'))
multinomialSize = 2; numLabels = 5;

%% Load
load 12022015.mat
txo_data1 = txo_data;
load 12062015.mat
txo_data2 = txo_data;
clear txo_data

%% Preprocess
[x1, y1] = raw2ready(txo_data1); 
[x2, y2] = raw2ready(txo_data2); 

x = [x1; x2]; y = [y1; y2];
clear txo_data1 txo_data2 x1 x2 y1 y2

[y, sortIdx] = sort(y);
x = x(sortIdx, :);


%% Fit to a Mixture of Laplacians (currently not useful)
% [ pdfs, phi, varargout ] = laplacianMixture( y, 2 );
% [ laplacePdfs, laplacePhi, phiHist, muHist, bHist ] = laplacianMixture( y, multinomialSize, 'diagnostics', 1);
% plotEM( y, phiHist, muHist, bHist, 1 );
% plotMixture( y, laplacePdfs, laplacePhi, [2,3] );

%% Fit to a Mixture of Gaussians (currently not useful)
% [ gaussPdfs, gaussPhi ] = gaussianMixture( y, multinomialSize);
% plotMixture( y, gaussPdfs, gaussPhi, [4,5] );

%% Cluster and Fit Distribution
% pdf = fitDistribution(y, 4); % pdf is a function handle
[pdf, idx, pdfs, phi] = fitDistribution(y, multinomialSize, 'diagnostics', 1);
plotCluster(y, pdf, idx, pdfs, phi, [6 7 8]);

%% Define l equal-probability subdomains
% labels = label(y, pdf, 10);
[labels, domain, cdf, probEdges, domainEdges] = label(y,pdf,numLabels,'diagnostics',1);
plotSubdomains(y, labels, domain, cdf, probEdges, domainEdges, [9 10]);

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