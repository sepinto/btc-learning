function out = btc_data2mat( data )
    struct2mat = @(x) cell2mat(struct2cell(x))';
    out = zeros(length(data), length(struct2mat(data{1})));
    for i=1:length(data)
        out(i,:) = struct2mat(data{i});
    end
    out = sparse(out);
end

