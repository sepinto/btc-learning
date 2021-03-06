function [ mntrain, mnpredict ] = multinomial( numClass )
% Returns training and classification funtions for the softmax regression
% of a multinomial distribution
%   Detailed explanation goes here

% Used to rehsape B so that mnrval can use it to predict
% reshapeB = @(B) [B(1:numClass-1)'; repmat(B(numClass:end),1,numClass-1)]
% mntrain = @(x,y) reshapeB(mnrfit(x, y, 'model', 'ordinal'));

mntrain = @(x,y) mnrfit(x, y );
% mnpredict = @(x,B) find( mnrval(B,x) == max(mnrval(B,x)));
mnpredict = @(x,B) maxIndx(mnrval(B,x));

end

function maxi = maxIndx( p )
    [~, maxi] = max(p, [], 2);
end

