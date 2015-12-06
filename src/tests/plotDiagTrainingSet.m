function [] = plotDiagTrainingSet( perfTrain, perfTest)
%Plots data gather from test_vs_train_error() function
    
    numFracs = size(perfTrain,2);
   % Plotting
   for n = 1:size(perfTrain,1)
       figure; hold;
       for i = 1:numFracs
          trainError(i) = perfTrain(n,i).ErrorRate;
          testError(i) = perfTest(n,i).ErrorRate;
       end
       plot(1:numFracs, trainError);
       plot(1:numFracs, testError);
       
       legend('training error', 'testing error');
       title('Error vs training set size');
       xlabel('m (training set size)');
       ylabel('Error Rate');
   end

end

