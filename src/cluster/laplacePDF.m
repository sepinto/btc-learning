function [ p ] = laplacepdf( x, mu, b )
%LAPLACEPDF implementation of the PDF of a Laplace Distribution. 
% mu & b must both be k-element vectors. The output will be a m x k matrix.

    assert(length(mu) == length(b));
    assert(sum(b <= 0) == 0); % b must be positive
    x = reshape(x,length(x),1);
    
    m = length(x); k = length(b);
    x = repmat(x,1,k); mu = repmat(mu,m,1); b = repmat(b,m,1);
    p = exp(- abs(x - mu) ./ b) ./ (2 * b);

end

