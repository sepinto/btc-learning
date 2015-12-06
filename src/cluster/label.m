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
    domainEdges = zeros(k+1,1); domainEdges(end) = Inf;

    for i=2:k
        domainEdges(i) = domain(find(cdf >= probEdges(i), 1));
    end
    labels = discretize(y, domainEdges);
    
    if diagnostics
        varargout{1} = domain;
        varargout{2} = cdf;
        varargout{3} = probEdges;
        varargout{4} = domainEdges;
    end
end

