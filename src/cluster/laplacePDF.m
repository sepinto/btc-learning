function [ p ] = laplacePDF( x, mu, b )
%LAPLACEPDF implementation of the PDF of a Laplace Distribution. x must be
% a m-element column vector and mu & b must both be k-element vectors. The
% output will be a m x k matrix.

assert(length(mu) == length(b));
assert(sum(b <= 0) == 0); % b must be positive
assert(length(x(1,:)) == 1); % x must be a column vector

m = length(x); k = length(b);
mu = reshape(mu, 1, k); b = reshape(b, 1, k);
x = repmat(x,1,k); mu = repmat(mu,m,1); b = repmat(b,m,1);
p = exp(- abs(x - mu) ./ b) ./ (2 * b);

end

