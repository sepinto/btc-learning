function [ pdfs, phi ] = gaussianMixture( data, k )
%GAUSSIANMIXTURE Summary of this function goes here
%   Detailed explanation goes here

    mdl = fitgmdist(data,k,'start','plus');
    
    pdfs = cell(k,1);
    for i=1:k
       pdfs{i} = @(d) normpdf(d,mdl.mu(i),mdl.Sigma(i));
    end
    
    phi = mdl.ComponentProportion;

end

