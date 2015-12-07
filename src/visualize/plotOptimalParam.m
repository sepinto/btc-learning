function [ ] = plotOptimalParam( pCorrect, C, gamma )
% Plots the Correct Rate of the combination of C's and gammas from the
% output of the optimalSVMParamters() function

figure;
imagesc(pCorrect);
colormap('jet'); colorbar;
set(gca,'XTick',1:size(gamma,2))
set(gca,'XTickLabel',log2(gamma))
xlabel('Log_2\gamma');
set(gca,'YTick',1:size(C,2))
set(gca,'YTickLabel',log2(C))
ylabel('Log_2c');
title('Correct Rate vs C and G')

end

