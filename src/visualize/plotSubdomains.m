function [out] = plotSubdomains(data, labels, domain, cdf, edges, fignums)
    assert(length(fignums) == 2);
    k = length(unique(labels));
    
    figure(fignums(1));
    clf
    plot(domain, cdf, 'linewidth', 2)
    hold on
    for l=2:k
        plot(domain, (l/k) * ones(length(domain),1), 'k', 'linewidth', 0.5)
        hold on
        plot(edges(l) * ones(2,1), [0,1], 'k', 'linewidth', 0.5)
        hold on
    end
    hold off
    title('Equal Probability Subdomains on CDF', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30)
    
    histEdges = @(data) linspace(1, round(max(data)), 1000);
    figure(fignums(2));
    clf
    for l=1:k
        histogram(data(labels == l), histEdges(data))
        hold on
    end
    hold off
    title('histogram colored by label', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30) 

end
    


