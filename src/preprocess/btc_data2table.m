function out = btc_data2table( data )
    mat = btc_data2mat(data);
    
    out = table(mat(:,1), mat(:,2), mat(:,3), mat(:,4),...
        'VariableNames', fieldnames(data{1})); 
end

