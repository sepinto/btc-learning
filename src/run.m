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

%% Test Different Algorithms

dummyweekday = dummyvar(x(:,1));
xdummy = [dummyweekday(:,2:end) x(:,2:end)];

[mnTrain, mnPred] = multinomial(numLabels);
[svmLinTrain, svmLinPred] = svm('linear');
[svmPolyTrain, svmPolyPred] = svm('poly');
[svmRadialTrain, svmRadialPred] = svm('radial');
[svmSigmoidTrain, svmSigmoidPred] = svm('sigmoid');


mdlsTrain = {   mnTrain ; svmLinTrain ; svmRadialTrain};
mdlsPred  = {   mnPred  ; svmLinPred ; svmRadialPred };

mdlsName = {'multinomial', 'svmLin', 'svmRad'};

[ptest,  ptrain] = kfoldValidation(5, xdummy, labels, {mnTrain}, {mnPred});
%[ptest,  ptrain] = kfoldValidation(5, full(xlr), labels, mdlsTrain, mdlsPred);

%% Find best C and gamma value for radial kernel svm (coarse)
C = 2.^(-15:2:13);
gamma = 2.^(-13:2:13);

C = 2.^(-[5 3 1]);
gamma = 2.^(-[5 3 1]);

[pCorrectTest, pCorrectTrain] = ...
    optimalSVMParameters(xdummy, labels, 'radial', C, gamma);

plotOptimalParam(pCorrectTest, C, gamma); title('Testing Correct Rate');
plotOptimalParam(pCorrectTrain, C, gamma); title('Training Correct Rate');

%% Diagnostics
[perfTrain, perfTest] = test_vs_train_error(xdummy, labels, {svmRadialTrain}, {svmRadialPred});
plotDiagTrainingSet(perfTrain, perfTest);