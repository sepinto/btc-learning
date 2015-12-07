function newData = curateFeatures( data )
%CURATEFEATURES changes giant integer values into, I think, more usable and
% interpretable real values and also removes values that are all one value
% or don't have any relation to time spent as UTXO.

% NOTE are we going to run into time zone issues here? We can't timezone 
% into account

newData = struct();

newData.beginTxn_weekday = unix2weekday(double(data.beginTxn_time));
newData.beginTxn_time = double(data.beginTxn_time) / 3600; % sec to hours
newData.beginTxn_numIns = double(data.beginTxn_numIns);
newData.beginTxn_numOuts = double(data.beginTxn_numOuts);

%newData.endTxn_weekday = unix2weekday(double(data.endTxn_time));

% If nonzero, the locktime is the first block when the txo may be redeemed.
% THIS GUARANTEES A MINIMUM LIFESPAN. Convert it to blocks from creation.
% Note: the max takes care of the case where its zero.
% Omitting because they are all 0's
% newData.locktime = max(0,...
%     double(data.beginTxn_locktime - data.beginTxn_height));
newData.value = double(data.value) * 10^-8; % Satoshi to BTC

% Don't need the following fields because...

% time and block height are scaled versions of each other. Only need one.
% newData.beginTxn_height = double(data.beginTxn_height);
% newData.endTxn_height = double(data.endTxn_height);

% Having both start and end time will clearly give perfect prediction. Only
% use one.
% newData.endTxn_time = double(data.endTxn_time) / 3600; % sec to hours

% locktime of redemption has no effect on this txo
% newData.endTxn_locktime = double(data.endTxn_locktime);

% All types are zero
% newData.type = double(data.type);

% Our model shouldn't have access to this data while predicting.
% newData.endTxn_numIns = double(data.endTxn_numIns);
% newData.endTxn_numOuts = double(data.endTxn_numOuts);


newData = {newData};
end

