function [out] = plotCluster(data, pdf, idx, pdfs, phi, fignums)
    assert(length(fignums) == 3);
    k = length(phi); histBins = 1e3; domainGranularity = 1e3;
    
    figure(fignums(1));
    clf
    plotHistByLabel(data, idx, histEdges(data, histBins));
    title('Histogram colored by cluster', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30) 

    figure(fignums(2));
    clf
    for l = 1:k
        clusterData = data(idx==l);
        
        subplot(floor(sqrt(k)), ceil(sqrt(k)), l)
        histogram(clusterData, histEdges(clusterData, histBins), 'Normalization', 'pdf')
        hold on
        plot(domain(clusterData, domainGranularity), pdfs{l}(domain(clusterData, domainGranularity)))
        set(gca,'fontsize',20)
        if l == 1
            title('MLE of each cluster (either Normal, Exp, or Laplace)', 'fontsize', 30, 'interpreter', 'latex')
        end
    end
    
    figure(fignums(3));
    clf
    histogram(data, histEdges(data, histBins), 'Normalization', 'pdf')
    hold on
    plot(domain(data, domainGranularity), pdf(domain(data, domainGranularity)));
end
    


