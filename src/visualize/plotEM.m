function [ out ] = plotEM( data, phiHist, muHist, bHist, fignums )
%PLOTEM Summary of this function goes here
%   Detailed explanation goes here
    assert(length(fignums) == 1);
    k = length(phiHist(1,:)); iters = length(phiHist(:,1));
    
    figure(fignums(1))
    for i=1:iters-1
        clf
        histogram(data, histEdges(data, 1000), 'Normalization', 'pdf');
        hold on
        for j=1:k
            plot(domain(data,1000), laplacepdf(domain(data,1000), muHist(i,j), bHist(i,j)), 'LineWidth', 2);
            hold on	
        end
        pause(1)
    end
    hold off

end

