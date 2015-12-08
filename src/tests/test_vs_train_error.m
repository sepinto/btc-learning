function [perfTest , perfTrain ] = test_vs_train_error( x,y, mdltrain, mdlPredict )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

perm = randperm(size(x,1));
x = x(perm, :);
y = y(perm);

trainFrac = 0.1:0.1:1;
numFracs = size(trainFrac,2);
numModels = size(mdltrain,1);
numSamples = size(x,1);


for n = 1:numModels
   for i = 1:numFracs
        train = mdltrain{n};
        classify = mdlPredict{n};
        
        % Divide up training data in test and train subset
        indicesTrain = 1:floor(0.7 * trainFrac(i) * numSamples);
        indicesTest  = max(indicesTrain)+1:floor(trainFrac(i)*numSamples);
        
        xTrain = x(indicesTrain,:);
        yTrain = y(indicesTrain,:);
        
        xTest  = x(indicesTest, :);
        yTest  = y(indicesTest, :);

        % Create model from training subset
        mdl = train( xTrain, yTrain);
        
        % For training error
        yTrain_pred = zeros(size(yTrain));
        for j = 1:size(xTrain,1)
           yTrain_pred(j) = classify(xTrain(j,:),mdl); 
        end
        
        % For testing error
        yTest_pred = zeros(size(yTest));
        for j = 1:size(xTest,1)
           yTest_pred(j) = classify(xTest(j,:),mdl); 
        end
        
        perfTrain(n,i) = classperf(yTrain, yTrain_pred);
        perfTest(n,i) = classperf(yTest, yTest_pred);
        
        display(['Size # ' num2str(i) ' of ' num2str(numFracs) ' completed']);
   end
end



end

