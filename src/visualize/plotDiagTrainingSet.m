function [] = plotDiagTrainingSet( perfTrain, perfTest, tsize)
%Plots data gather from test_vs_train_error() function
    
    fontLabel = 15;
    fontTick  = 12;
    
    width = 6;
    height = 5;
    
    sizes = floor( (0.1:0.1:1) * tsize);

    numFracs = size(perfTrain,2);
   % Plotting
   for n = 1:size(perfTrain,1)
       figure(  'Units', 'inches', ...
                'Position', [0 0 width height], ...
                'PaperPosition', [0 0 width height], ...
                'PaperPositionMode', 'manual'); 
       hold;
       set(gcf,'color','w');
       
       for i = 1:numFracs
          trainError(i) = perfTrain(n,i).ErrorRate;
          testError(i) = perfTest(n,i).ErrorRate;
       end
       plot(sizes, trainError,'LineWidth', 2);
       plot(sizes, testError, 'LineWidth', 2);
       
       leg = legend('training error', 'testing error');
       set(leg, 'FontSize', fontTick);       
       set(gca, 'FontSize', fontTick);
       title('Error vs training set size', 'FontSize', fontLabel, ...
             'FontWeight', 'normal');
       xlabel('m (training set size)', 'FontSize', fontLabel);
       ylabel('Error Rate', 'FontSize', fontLabel);
       box on;
       
   end

end

