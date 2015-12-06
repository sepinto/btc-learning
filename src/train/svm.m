function [train, predict] = svm( kernel_type, C, gamma )
%SVMTRAIN train a model using libsvm

switch lower(kernel_type)
    case 'linear'
        kernel = '0';
    case 'poly'
        kernel = '1';
    case 'radial'
        kernel = '2';
    case 'sigmoid'
        kernel = '3';
    otherwise
        disp('Error: Kernel type did not match');
end

options = ['-s 0 -t ' kernel ];

if(exist('C', 'var') == 1)
   options = [options [' -c ' num2str(C)]];
end

if(exist('gamma', 'var') == 1)
   options = [options [' -g ' num2str(gamma)]];
end
    
train = @(x,y) svmtrain(y,x, options);
predict = @(x,mdl) svmpredict( 0, x, mdl);

% C = max(y) - min(y);
% model = svmtrain(y, x, ['-s 3 -t 0 -c ', num2str(C)]);

end

