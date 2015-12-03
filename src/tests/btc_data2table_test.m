T = btc_data2table(x);
fields = fieldnames(x{1});

for i=1:length(x)
    for j=1:length(fields)
        assert(T(i,j).(fields{j}) == x{i}.(fields{j}))
    end
end
