function [out] = plotCluster(data, pdf, idx, phi, pdfs, fignums)
    assert(length(fignums) == 3);
    
    k = length(phi);
    edges = @(data) linspace(1, round(max(data)), 1000);
    domain = @(data) linspace(min(data), max(data), length(data));

    figure(fignums(1));
    clf
    for l=1:k
        histogram(data(idx == l), edges(data))
        hold on
    end
    hold off
    title('histogram colored by cluster', 'fontsize', 30, 'interpreter','latex')
    set(gca,'fontsize',30) 

    figure(fignums(2));
    clf
    for l = 1:k
        clusterData = data(idx==l);
        
        subplot(floor(sqrt(k)), ceil(sqrt(k)), l)
        histogram(clusterData, edges(clusterData), 'Normalization', 'pdf')
        hold on
        plot(domain(clusterData), pdfs{l}(domain(clusterData)))
        set(gca,'fontsize',20)
        if l == 1
            title('MLE of each cluster (either Normal, Exp, or Laplace)', 'fontsize', 30, 'interpreter', 'latex')
        end
    end
    
    figure(fignums(3));
    clf
    histogram(data, edges(data), 'Normalization', 'pdf')
    hold on
    plot(domain(data), pdf(domain(data)));
end
    


