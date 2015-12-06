function [out] = plotMixture(data, pdfs, phi, fignum)
    assert(length(fignum) == 2);
    
    k = length(phi);
    
    figure(fignum(1))
    clf
    histogram(data, histEdges(data,1000), 'Normalization', 'pdf');
    hold on
    for i=1:k
        plot(domain(data,1000), pdfs{i}(domain(data,1000)), 'LineWidth', 2);
        hold on
    end
    hold off
    
    figure(fignum(2))
    clf
    histogram(data, histEdges(data,1000), 'Normalization', 'pdf');
    hold on
    plot(domain(data,1000), totalpdf(domain(data,1000),pdfs,phi),'linewidth',2)
    
end
    



