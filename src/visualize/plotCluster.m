load 12022015

[x, y] = raw2ready(txo_data);
data = sort(y);

k = 4; 

edges = @(data) linspace(1, round(max(data)), 1000);
domain = @(data) linspace(min(data), max(data), length(data));

% k means clustering
idx = kmeans(data,k,'distance','cityblock','emptyaction','drop');
phi = zeros(k, 1);

figure(1)
clf
for l=1:k
    histogram(data(idx == l), edges(data))
    hold on
end
title('histogram colored by cluster', 'fontsize', 30, 'interpreter','latex')
set(gca,'fontsize',30) 

figure(2)
clf
% Fit each cluster to either Gaussian, Exponential, or Laplacian distribution
for l = 1:k
    clusterData = data(idx==l);
    phi(l) = length(clusterData) / length(data);
    
    subplot(floor(sqrt(k)), ceil(sqrt(k)), l)
    histogram(clusterData, edges(clusterData), 'Normalization', 'pdf')
    hold on
    
    expFit = mle(clusterData, 'distribution', 'exp');
    lapFit = mle(clusterData,'pdf',@laplacepdf,'start',[mean(clusterData), sqrt(var(clusterData)/2)]);
    normFit = mle(clusterData);
    [~, maxInd] = max([sum(log(exppdf(clusterData, expFit))),...
        sum(log(laplacepdf(clusterData, lapFit(1), lapFit(2)))),...
        sum(log(normpdf(clusterData, normFit(1), normFit(2))))]);
    
    switch maxInd
        case 1
            plot(domain(clusterData), exppdf(domain(clusterData), expFit))
        case 2
            plot(domain(clusterData), laplacepdf(domain(clusterData), lapFit(1), lapFit(2)))
        case 3
            plot(domain(clusterData), normpdf(domain(clusterData), norm(1), norm(2)))
    end
    
    set(gca,'fontsize',20)
    if l == 1
        title('MLE of each cluster (either Normal, Exp, or Laplace)', 'fontsize', 30, 'interpreter', 'latex')
    end
end

% Try out function
pdf = fitDistribution(data, k);
figure(4)
clf
histogram(data, edges(data), 'Normalization', 'pdf')
hold on
plot(domain(data), pdf(domain(data)));





