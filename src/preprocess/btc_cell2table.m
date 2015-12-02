function [ out ] = btc_cell2table( cellArray )
    mat = btc_cell2mat(cellArray);
    
    out = table(mat(:,1), mat(:,2), mat(:,3), mat(:,4),...
        'VariableNames', fieldnames(cellArray{1})); 
end

