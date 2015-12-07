function [ x, y ] = raw2ready( txo_data )
%RAW2READY take raw data from python output and make it ready for learning

curated_data = cellfun(@curateFeatures, txo_data);
x = btc_data2mat(curated_data);
[txnVolume, btcPrices] = getCSVData( txo_data );
x = [x, txnVolume, btcPrices];
y = cellfun(@getLifespan, txo_data)';
x = sparse(x);

end

