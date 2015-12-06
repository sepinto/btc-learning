function [ out ] = plotHistByLabel( data, labels, edges )

    uniq = unique(labels);
    for k=1:length(uniq);
        histogram(data(labels == uniq(k)), edges)
        hold on
    end
    hold off

end

