function [lrTrain , lrTest] = trainLinReg( robustopts )
% Train linear regression using Matlab Toolbox
%   Can add parameters to training algorithm in the arguments here that
%   will be reflected in the lrTrain function handle that is returned
%   x - features for training data
%   y - classifications for training data


lrTrain = @(x,y) fitlm(x,y, 'CategoricalVars', 1, 'RobustOpts', robustopts);
lrTest  = @(x,lrmdl) lrmdl.predict(x);

end

