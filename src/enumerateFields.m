function [ varargout ] = enumerateFields( cell )
    fields = fieldnames(cell);
    for i=1:length(fields)
        varargout{i} = cell.(fields{i});
    end
end

