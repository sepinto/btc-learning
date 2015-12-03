function [ lifespan ] = getLifespan( data )
%GETLIFESPAN get the lifespan of a UTXO in blocks
lifespan = double(data.endTxn_height - data.beginTxn_height);
end

