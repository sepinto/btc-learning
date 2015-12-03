function [lrModel , lrTest ] = trainLinReg( x, y )
% Train linear regression using Matlab Toolbox
%rank(full(x));
%svd(full(x));
lrModel = fitlm(x,y, 'CategoricalVars', [1]);
%lrModel = fitlm(x,y);

lrTest = @testLinReg;

end

function [y] = testLinReg( x, lrModel)
% Outputs a result of linear regression model, lrModel, run on new test
% point with features x
%   x       - row of features to run on
%   lrModel - linreg model from trainLinReg

y = lrModel.predict(x);

end

