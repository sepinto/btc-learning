load 12022015

[x, y] = raw2ready(txo_data);
data = sort(y(y > 1));
% data = data(1:300);

k = 2; domain = linspace(min(data), max(data), 100000)';
[phiHist, muHist, bHist, iters] = laplacianMixture( data, k );

figure(1)
for i=1:iters-1
    clf
	histogram(data, 100, 'Normalization', 'pdf');
	hold on
	for j=1:k
		plot(domain, laplacePDF(domain, muHist(i,j), bHist(i,j)), 'LineWidth', 2);
		hold on	
	end
	pause(1)
end
hold off

%% Gaussian Mixture
mdl = fitgmdist(data,k,'start','plus');

figure(2)
clf
% subplot(2,1,1)
histogram(data, 200, 'Normalization', 'pdf');
hold on
% subplot(2,1,2)
for i=1:k
    plot(domain, normpdf(domain, mdl.mu(i), mdl.Sigma(i)), 'LineWidth', 2);
    hold on
end
hold off

