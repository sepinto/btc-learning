addpath(genpath('.'))
multinomialSize = 2; numLabels = 5;

%% Load
load 12022015.mat

%% Preprocess
[x, y] = raw2ready(txo_data); 

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

xlr = x; xlr(:,5:6) = [];
dummyweekday = dummyvar(xlr(:,1));
xdummy = [dummyweekday(:,2:end) xlr(:,2:end)];

[mnTrain, mnPred] = multinomial(numLabels);
[svmLinTrain, svmLinPred] = svm('linear');
[svmPolyTrain, svmPolyPred] = svm('poly');
[svmRadialTrain, svmRadialPred] = svm('radial');
[svmSigmoidTrain, svmSigmoidPred] = svm('sigmoid');


mdlsTrain = {   mnTrain ; svmLinTrain ;
                svmPolyTrain ; svmRadialTrain ;
                svmSigmoidTrain};
            
mdlsPred  = {   mnPred  ; svmLinPred ;
                svmPolyPred; svmRadialPred ;
                svmSigmoidPred};

mdlsName = {'multinomial', 'svm'};

[ptest,  ptrain] = kfoldValidation(5, full(xlr), labels, {svmRadialTrain}, {svmRadialPred});

%% Find best C and gamma value for radial kernel svm (coarse)
C = [2^-5, 2^-3, 2^-1, 2^1, 2^3, 2^5];
G = [2^-15, 2^-13, 2^-11, 2^-9, 2^-7, 2^-5];

numC = size(C,2);
numG = size(G,2);

svmRadialTrain = cell(numC,numG);
svmRadialPred  = cell(numC,numG);

for i = 1:numC
    for j = 1:numG
        [svmRadialTrain{i,j} , svmRadialPred{i,j}] = svm('radial', C(i), G(j));
    end
end

[pRadTest, pRadTrain] = kfoldValidation(5, full(xdummy), labels, svmRadialTrain(:), svmRadialPred(:));

for i = 1:numC
    for j = 1:numG
        pCorrectTest(i,j) = pRadTest( numG*(i-1)+ numG).CorrectRate;
        pCorrectTrain(i,j) = pRadTrain( numG*(i-1)+ numG).CorrectRate;
    end
end
figure; imagesc(log2(C),log2(G),pCorrectTest);
xlabel('gamma');
ylabel('C');
title('Testing Correct Rate vs C and G');

figure; imagesc(log2(C),log2(G),pCorrectTrain2);
xlabel('gamma');
ylabel('C');
title('Training Correct Rate vs C and G');

%% Diagnostics
[perfTrain, perfTest] = test_vs_train_error(xdummy, labels, {svmRadialTrain}, {svmRadialPred});
plotDiagTrainingSet(perfTrain, perfTest);