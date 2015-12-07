function [ pCorrectTest, pCorrectTrain ] = optimalSVMParameters( x, y, kernel, C, gamma )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numC = size(C,2);
numG = size(gamma,2);

svmTrain = cell(numC,numG);
svmPred  = cell(numC,numG);

for i = 1:numC
    for j = 1:numG
        [svmTrain{i,j} , svmPred{i,j}] = svm(kernel, C(i), gamma(j));
    end
end

[pRadTest, pRadTrain] = kfoldValidation(5, full(x), y, ...
                                        svmTrain(:), svmPred(:));

for i = 1:numC
    for j = 1:numG
        pCorrectTest(i,j) = pRadTest( numG*(i-1)+ j).CorrectRate;
        pCorrectTrain(i,j) = pRadTrain( numG*(i-1)+ j).CorrectRate;
    end
end

end

