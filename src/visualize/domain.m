function [ d ] = domain( data, n )
%DOMAIN Summary of this function goes here
%   Detailed explanation goes here

    d = linspace(min(data), max(data), n);

end

