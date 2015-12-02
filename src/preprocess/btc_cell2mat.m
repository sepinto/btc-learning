function [ out ] = btc_cell2mat( cellArray )
    enumerate = @(c) cell2mat(struct2cell(c))';
    out = zeros(length(cellArray), length(enumerate(cellArray{1})));
    for i=1:length(cellArray)
        out(i,:) = enumerate(cellArray{i});
    end
end

