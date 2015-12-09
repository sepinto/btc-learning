addpath(genpath('.'))
multinomialSize = 6; numLabels = 10;

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

plotHistogram(y, [1 2 3]);


%% Fit to a Mixture of Laplacians (currently not useful)
% [ pdfs, phi, varargout ] = laplacianMixture( y, multinomialSize );
% [ laplacePdfs, laplacePhi, phiHist, muHist, bHist ] = laplacianMixture( y, multinomialSize, 'diagnostics', 1);
% plotEM( y, phiHist, muHist, bHist, 1 );
% plotMixture( y, laplacePdfs, laplacePhi, [2,3] );

%% Fit to a Mixture of Gaussians (currently not useful)
% [ gaussPdfs, gaussPhi ] = gaussianMixture( y, multinomialSize);
% plotMixture( y, gaussPdfs, gaussPhi, [4,5] );

%% Cluster and Fit Distribution
% pdf = fitDistribution(y, multinomialSize); % pdf is a function handle
[pdf, idx, pdfs, phi] = fitDistribution(y, multinomialSize, 'diagnostics', 1);
plotCluster(y, pdf, idx, pdfs, phi, [6 7 8]);

%% Define l equal-probability subdomains
% labels = label(y, pdf, numLabels);
domainEdges = [0; y(round((1:numLabels-1)*length(y)/numLabels)); Inf];
labels = discretize(y, domainEdges);

disp('Domain Edges for actual')
disp(domainEdges)
disp('Fraction of labels in each bin for actual')
for i=1:numLabels
    disp(length(labels(labels == i)) / length(labels))
end

figure(9);
clf
plotHistByLabel(y, labels, histEdges(y, 1000))
title('histogram colored by label', 'fontsize', 30, 'fontweight','normal')
set(gca,'fontsize',30)

[CDFlabels, domain, cdf, probEdges, domainEdges] = label(y,pdf,numLabels,'diagnostics',1);
plotSubdomains(y, CDFlabels, domain, cdf, probEdges, domainEdges, [10 11]);

disp('Domain Edges for modelled')
disp(domainEdges)
disp('Fraction of labels in each bin for modelled')
for i=1:numLabels
    disp(length(CDFlabels(CDFlabels == i)) / length(CDFlabels))
end


%% Train
%svmModel = svm(x, y);
%[linRegModel, lrPredict] = trainLinReg(x,y);
% ... etc

%% Test Different Algorithms

dummyweekday = dummyvar(x(:,1));
xdummy = [dummyweekday(:,2:end) x(:,2:end)];

C = 2^(-21);
gamma = 2^(-16.5);
% [mnTrain, mnPred] = multinomial(numLabels);
% [svmLinTrain, svmLinPred] = svm('linear');
% [svmPolyTrain, svmPolyPred] = svm('poly');
[svmRadialTrain, svmRadialPred] = svm('radial');
% [svmSigmoidTrain, svmSigmoidPred] = svm('sigmoid');


% mdlsTrain = {   mnTrain ; svmLinTrain ; svmRadialTrain};
% mdlsPred  = {   mnPred  ; svmLinPred ; svmRadialPred };

% mdlsName = {'multinomial', 'svmLin', 'svmRad'};


%[ptest,  ptrain] = kfoldValidation(5, xdummy, labels, {svmRadialTrain}, {svmRadialPred});
%[ptest,  ptrain] = kfoldValidation(5, full(xlr), labels, mdlsTrain, mdlsPred);

%% Find best C and gamma value for radial kernel svm (coarse)
C = 2.^([10:3:25])
gamma = 2.^([-20:3:-5])

[pCorrectTest, pCorrectTrain] = ...
    optimalSVMParameters(xdummy, labels, 'radial', C, gamma);

plotOptimalParam(pCorrectTest, C, gamma); title('Testing Correct Rate');
plotOptimalParam(pCorrectTrain, C, gamma); title('Training Correct Rate');

%% Diagnostics
%[perfTrain, perfTest] = test_vs_train_error(xdummy, labels, {svmRadialTrain}, {svmRadialPred});
%plotDiagTrainingSet(perfTrain, perfTest);