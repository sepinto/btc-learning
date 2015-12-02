function [ t ] = btc_cell2table( cellArray )
%btc_cell2table converts the cell array we get from numpy into a table
%   For some reason, Matlab's built in cell2table doesn't work with our
%   data so this fcn takes care of it.
    [numPeerSpends, type, locktime, value] = cellfun(@enumerateFields,...
        cellArray, 'UniformOutput',1);
    
    t = table(numPeerSpends', type', locktime', value');
end

