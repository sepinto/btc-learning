function [ pe, pdf_expmixture ] = fitExponential( time )
% Fits a Exponential distribution to the "output" of our system, i.e the
% time a UTXO has been on the blockchain
% time - Nx1 vector of times spent on the blockchain

pdf_expmixture = @(x, p, lambda1, lambda2) ...
    p*exppdf(x,lambda1) + (1-p)*exppdf(x,lambda2);

pStart = 0.5;
lambdaStart = [1 2000];
start = [pStart lambdaStart];

lb = [0 0 0];
ub = [1 Inf Inf];

o = statset('mlecustom');
o.FunValCheck = 'off';
o.MaxIter = 2000;

[pe, temp] = mle(time, 'pdf', pdf_expmixture, 'start', start, ...
                'lower', lb, 'upper', ub, 'options',o);
temp
end

