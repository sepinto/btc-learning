function [out] = plotSubdomains(data, labels, domain, cdf, probEdges, domainEdges, fignums)
    assert(length(fignums) == 2);
    k = length(unique(labels)); histBins = 1e3;
    
    figure(fignums(1));
    clf
    plot(domain, cdf, 'linewidth', 2)
    hold on
    for l=2:k
        plot([min(domain) max(domain)], probEdges(l)*ones(2,1), 'k', 'linewidth', 0.5)
        hold on
        plot(domainEdges(l) * ones(2,1), [0,1], 'k', 'linewidth', 0.5)
        hold on
    end
    hold off
    title('Equal Probability Subdomains on CDF', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30)
    
    figure(fignums(2));
    clf
    plotHistByLabel(data, labels, histEdges(data, histBins))
    title('histogram colored by label', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30) 

end
    


