function [ dist ] = xvalidation10( x,y, mdltrain )
% 10-fold cross validation
%   x - training data features
%   y - training data output
%   mdltrain - function handle to model training that takes x and y, and
%   outputs a model

perm = randperm(size(x,1));
x = x(perm, :);
y = y(perm);

foldSize = floor(size(x,1)/10);
dist = zeros(10, foldSize);

for i = 1:10
    % Indices corresponding to particular fold
    subsetTest = (i-1)*foldSize + 1 : i*foldSize;

    % Divide up training data in test and train subset
    xtest = x(subsetTest,:);
    ytest = y(subsetTest,:);

    xtrain = x; xtrain(subsetTest,:) = [];
    ytrain = y; ytrain(subsetTest,:) = [];

    % Create model from training subset
    [mdl, mdlPredict] = mdltrain( xtrain, ytrain);
    
    % Predict new y's from new x's in test subset
    ypred = zeros(size(xtest,1),1);
    for j = 1:size(xtest,1)
        ypred(j) = mdlPredict(xtest(j,:), mdl);
    end
    dist(i,:) = (ypred - ytest).^2;
    
    display(['Fold # ' num2str(i) ' completed']);
end

end

