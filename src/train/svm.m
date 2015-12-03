function model = svm( x, y )
%SVMTRAIN train a model using libsvm

C = max(y) - min(y);
model = svmtrain(y, x, ['-s 3 -t 0 -c ', num2str(C)]);

end

