M = btc_data2mat(x);
fields = fieldnames(x{1});

for i=1:length(x)
    for j=1:length(fields)
        assert(M(i,j) == x{i}.(fields{j}))
    end
end