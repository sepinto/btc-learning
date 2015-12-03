function [ x, y ] = btc_data2mat( data )
    struct2mat = @(x) cell2mat(struct2cell(x))';
    x = zeros(length(data), length(struct2mat(data{1})));
    y = zeros(length(data), 1);
    for i=1:length(data)
        x(i,:) = struct2mat(data{i});
        y(i) = data{i}.endTxn_height - data{i}.beginTxn_height;
    end
    x = sparse(x);
end

