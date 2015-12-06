function [ lifespan ] = getLifespan( data )
%GETLIFESPAN get the lifespan of a UTXO in blocks
lifespan = double(data.endTxn_time - data.beginTxn_time) / 3600; % in hours
lifespan = max(lifespan, 0);
end

