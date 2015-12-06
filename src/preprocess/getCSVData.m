function [ btcPrice, txnVolume ] = getCSVData( txo_data )
%GETCSVDATA loads two downloaded csv files and retrieves bitcoin price and
%transaction volume determined mapped from an array of timestamps (UNIX
%time in seconds).

    fid = fopen('btcPrice.csv');
    priceData = textscan(fid,'%s %f','Delimiter',',');
    fclose(fid);

    fid = fopen('txnVolume.csv');
    volumeData = textscan(fid,'%s %f','Delimiter',',');
    fclose(fid);

    assert(length(priceData{1}) == length(volumeData{1}));
    assert(strcmp(priceData{1}{1}, volumeData{1}{1}));
    
    map = containers.Map('KeyType','double', 'ValueType','any');
    days = length(volumeData{1});
    for i=1:days
        tmp.price = priceData{2}(i);
        tmp.volume= volumeData{2}(i);
        map(datenum(priceData{1}{i})) = tmp;
    end
    
    n = length(txo_data); btcPrice = zeros(n, 1); txnVolume = zeros(n, 1);
    for i=1:n
        date = floor(txo_data{i}.beginTxn_time / 86400) + datenum(1970,1,1);
        tmp = map(date);
        btcPrice(i) = tmp.price;
        txnVolume(i) = tmp.volume;
    end

end

