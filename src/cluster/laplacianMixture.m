function [ phiHist, muHist, bHist, iters ] = laplacianMixture( data, k )
%LAPLACIANMIXTURE models data as a mixture of k laplacians
%   Each sample (row of data) has probability phi(k) of belonging to distribution k,
%   definied as Laplacian(mu(k), b(k)).
    hardMin = 1e-5; epsilon = 1e-3; maxIters = 50;
    log_likelihood = @(PDF, PHI) sum( log(PDF * PHI') );
    
    assert(length(data(1,:)) == 1); % data must be a column vector
    if ~issorted(data)
        data = sort(data);
    end
    m = length(data);
    
    % matrices needed for m step
    beforeTri = tril(ones(m));
    includingTri = beforeTri + eye(m);
    
    phi = ones(1,k) / k; mu = ones(1,k); b = ones(1,k);
    phiHist = zeros(maxIters, k); muHist = zeros(maxIters, k); bHist = zeros(maxIters, k);
    % need to perturb phi
    for i=1:k-1
        if mod(i,2) == 1
            r = rand / k;
            phi(i) = phi(i) + r;
        else
            phi(i) = phi(i) - r;
        end
    end
    
    iters = 1; prevLikelihood = Inf;
    while iters < maxIters
        %% Update iteration state and check convergence
        phiHist(iters,:) = phi; muHist(iters,:) = mu; bHist(iters,:) = b;
        iters = iters + 1;
        
        pdf = max(laplacePDF(data, mu, b), hardMin);
        currLikelihood = log_likelihood(pdf, phi);
        if abs(prevLikelihood - currLikelihood) < epsilon
            break
        else
            prevLikelihood = currLikelihood;
        end

        %% E Step
        w = pdf .* ((1./(pdf * phi')) * phi);

        %% M Step
        % Store this term b/c it's used a lot
        sum_wi = sum(w,1);
        
        % update phi
        phi = sum_wi / m;

        for j=1:k
            fun = @(theta) sum(w(:,j) .* abs(data - theta(1)) / (-theta(2))...
                 + log(-theta(2)));
            theta = fmincon(fun, [mu(j), -1 * b(j)], [0, 0; 0, 1], [0; 0]);
            mu(j) = theta(1); b(j) = -1 * theta(2);
            
            % update mu
%             l = find(beforeTri * w(:,j) < 0.5 * sum_wi(j) & ...
%                 includingTri * w(:,j) >= 0.5 * sum_wi(j), 1);
%             mu(j) = data(l);
            
            % update b
%             b(j) = sum(w(:,j) .* abs(data - mu(j)))/sum_wi(j);
        end
    end
end

