function [ edges ] = histEdges( data, n )
%HISTEDGES Summary of this function goes here
%   Detailed explanation goes here
    edges = linspace(0, round(max(data)), n);
end

