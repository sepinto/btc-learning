function [ ] = plotOptimalParam( pCorrect, C, gamma, figtitle )
% Plots the Correct Rate of the combination of C's and gammas from the
% output of the optimalSVMParamters() function
fontSize = 15;
width = 5;
height = 4;

figure(  'Units', 'inches', ...
         'Position', [0 0 width height], ...
         'PaperPosition', [0 0 width height], ...
         'PaperPositionMode', 'manual'); 
     
set(gcf,'color','w');
imagesc(pCorrect);
colormap('jet'); colorbar;
set(gca,'XTick',1:size(gamma,2))
set(gca,'XTickLabel',log2(gamma), 'FontSize', 12)
set(gca,'YTick',1:size(C,2));
set(gca,'YTickLabel',log2(C), 'FontSize', 12);
xlabel('Log_2\gamma', 'FontSize', fontSize);
ylabel('Log_2c', 'FontSize', fontSize);
if(exist('figtitle','var')==1)
    title(figtitle, 'FontSize', 15, 'FontWeight', 'normal');
end

end

