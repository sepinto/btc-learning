function [ labels, varargout ] = label( y, pdf, k, varargin)
%LABEL Summary of this function goes here
%   Detailed explanation goes here

    % Validate and parse input arguments
    p = inputParser;
    addParameter(p,'diagnostics',0);
    parse(p,varargin{:});
    diagnostics = p.Results.diagnostics;
    
    granularity = 1e5;
    domain = linspace(min(y),max(y),granularity);
    cdf = cumsum(pdf(domain));
    cdf = (cdf - min(cdf)) / (max(cdf) - min(cdf)); % Normalize

    probEdges = linspace(0,1,k+1);
    %probEdges = [0 (1 - 1./exp(1:k)) 1];
    edges = zeros(k+1,1); edges(end) = Inf;
    for i=2:k
        edges(i) = domain(find(cdf >= probEdges(i), 1));
    end
    labels = discretize(y, edges);
    
    if diagnostics
        varargout{1} = domain;
        varargout{2} = cdf;
        varargout{3} = edges;
    end
end

