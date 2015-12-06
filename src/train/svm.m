function [train, predict] = svm( )
%SVMTRAIN train a model using libsvm

train = @(x,y) svmtrain(y,x,'-s 0 -t 0');
predict = @(x,mdl) svmpredict( 0, x, mdl);

% C = max(y) - min(y);
% model = svmtrain(y, x, ['-s 3 -t 0 -c ', num2str(C)]);

end

