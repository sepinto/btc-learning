function [ perf_test, perf_train] = kfoldValidation( k,x,y,mdltrain,mdlPredict )
% k-fold cross validation
%   k - number of folds to use
%   x - training data features
%   y - training data output
%   mdltrain - function handle to model training that takes x and y, and
%   outputs a model

perm = randperm(size(x,1));
x = x(perm, :);
y = y(perm);

foldSize = floor(size(x,1)/k);
dist = zeros(k, foldSize);
numModels = size(mdltrain, 1);

for n = 1:numModels
    ypred = zeros(k, foldSize);
    ytrain_pred = zeros(k, (k-1)*foldSize+1);
    tic
    for i = 1:k
        train = mdltrain{n};
        classify = mdlPredict{n};
        
        % Indices corresponding to particular fold
        subsetTest = (i-1)*foldSize + 1 : i*foldSize;

        % Divide up training data in test and train subset
        xtest = x(subsetTest,:);
        ytest = y(subsetTest,:);

        xtrain = x; xtrain(subsetTest,:) = [];
        ytrain = y; ytrain(subsetTest,:) = [];

        % Create model from training subset
        mdl = train( xtrain, ytrain);

        % Checking training error
        ytrain_pred(i,:) = classify(xtrain,mdl);
        ytrain_true(i,:) = ytrain;
        
        % Predict new y's from new x's in test subset
        ypred(i,:) = classify(xtest,mdl);
        ytrue(i,:) = ytest;
        
        display(['Fold # ' num2str(i) ' completed']);
    end
    perf_test(n) = classperf(ytrue(:), ypred(:));
    perf_train(n) = classperf(ytrain_true(:), ytrain_pred(:));
    t = toc;
    display([   'Model # ' num2str(n) ' of ' num2str(size(mdltrain,1)) ...
                ' completed in ' num2str(t) ' seconds']);
end

end

