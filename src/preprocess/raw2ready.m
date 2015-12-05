function [ x, y ] = raw2ready( txo_data )
%RAW2READY take raw data from python output and make it ready for learning

curated_data = cellfun(@curateFeatures, txo_data);
x = btc_data2mat(curated_data);
y = cellfun(@getLifespan, txo_data)';

[y,sortIdx] = sort(y);
x = x(sortIdx, :);

end

