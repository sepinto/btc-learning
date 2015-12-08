function [out] = plotCluster(data, pdf, idx, pdfs, phi, fignums)
    assert(length(fignums) == 3);
    k = length(phi); histBins = 1e3; domainGranularity = 1e3;
    
    figure(fignums(1));
    clf
    plotHistByLabel(data, idx, histEdges(data, histBins));
    title('Histogram colored by cluster', 'fontsize', 30)
    set(gca,'fontsize',30) 

    figure(fignums(2));
    clf
    for l = 1:k
        clusterData = data(idx==l);
        
        subplot(1, k, l)
        histogram(clusterData, histEdges(clusterData, histBins),'Normalization', 'pdf')
        
        hold on
        plot(domain(clusterData, domainGranularity), pdfs{l}(domain(clusterData, domainGranularity)), 'k', 'linewidth', 2)
        set(gca,'fontsize',20)
        if l == 1
            title('Maximum Likelihood Distribution for Each Cluster', 'fontsize', 30)
            axis([0 2000 0 0.01])
        end
    end
    
    figure(fignums(3));
    clf
    histogram(data, histEdges(data, histBins), 'Normalization', 'pdf')
    hold on
    plot(domain(data, domainGranularity), pdf(domain(data, domainGranularity)));
end
    


