function prob = totalpdf(data, pdfs, phi)
%TOTALPDF Sum of k pdfs each with weight phi(k)
    
    assert(sum(phi) == 1);
    prob = zeros(length(data),1);
    for k=1:length(pdfs)
       prob = prob + reshape(pdfs{k}(data), length(data), 1) * phi(k);
    end
    
end

