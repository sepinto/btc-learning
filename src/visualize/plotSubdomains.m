function [out] = plotSubdomains(data, labels, domain, cdf, probEdges, domainEdges, fignums)
    assert(length(fignums) == 2);
    k = length(unique(labels)); histBins = 1e3;
    
    figure(fignums(1));
    clf
    subplot(2,1,1)
    plot(domain, cdf,'k', 'linewidth', 2)
    title('Numerical CDF of Fitted Distribution', 'fontsize', 30, 'Interpreter','latex')
    xlabel('Hours','fontsize',25,'interpreter','latex')
    set(gca,'fontsize',30)
    axis([0 15000 0 1])
    
    
    subplot(2,1,2)
    plot(domain, cdf, 'k', 'linewidth', 2)
    hold on
    for l=2:k
        plot([min(domain) max(domain)], probEdges(l)*ones(2,1), 'k', 'linewidth', 0.5)
        hold on
        plot(domainEdges(l) * ones(2,1), [0,1], 'k', 'linewidth', 0.5)
        hold on
    end
    hold off
    axis([0 300 0 1])
    xlabel('Hours','fontsize',25,'interpreter','latex')
    title('Equal Probability Subdomains on CDF', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30)
    
    shortData = data(labels < max(labels));
    figure(fignums(2));
    clf
    plotHistByLabel(shortData, labels(labels < max(labels)), histEdges(shortData, histBins))
    axis([0 200 0 500])
    title('histogram colored by label', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30) 

end
    


