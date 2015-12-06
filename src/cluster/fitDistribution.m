function [ pdfFunction, varargout ] = fitDistribution( data, k, varargin )
%FITDISTRIBUTION Summary of this function goes here
%   Detailed explanation goes here
    
    % Validate and parse input arguments
    p = inputParser;
    addParameter(p,'diagnostics',0);
    parse(p,varargin{:});
    diagnostics = p.Results.diagnostics;
    
    assert(issorted(data));
    
    % k means clustering
    idx = kmeans(data,k,'distance','cityblock','emptyaction','drop');

    % Multinomial probabilities
    phi = zeros(k, 1);

    % Fit each cluster to either Gaussian, Exponential, or Laplacian distribution
    pdfs = cell(k,1);
    for l = 1:k
        clusterData = data(idx==l);
        % TODO could maybe do Laplace smoothing here?
        phi(l) = length(clusterData) / length(data);

        expFit = mle(clusterData, 'distribution', 'exp');
        lapFit = mle(clusterData,'pdf',@laplacepdf,'start',[mean(clusterData), sqrt(var(clusterData)/2)]);
        normFit = mle(clusterData);
        [~, maxInd] = max([sum(log(exppdf(clusterData, expFit))),...
            sum(log(laplacepdf(clusterData, lapFit(1), lapFit(2)))),...
            sum(log(normpdf(clusterData, normFit(1), normFit(2))))]);

        switch maxInd
            case 1
                pdfs{l} = @(d) exppdf(d, expFit);
            case 2
                pdfs{l} = @(d) laplacepdf(d, lapFit(1), lapFit(2));
            case 3
                pdfs{l} = @(d) normpdf(d, normFit(1), normFit(2));
        end
    end
    
    pdfFunction = @(d) totalpdf(d, pdfs, phi);
    
    if diagnostics
        varargout{1} = idx;
        varargout{2} = pdfs;
        varargout{3} = phi;
    end
end

