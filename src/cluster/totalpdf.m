function prob = totalpdf(data, pdfs, phi)
    prob = zeros(length(data),1);
    for k=1:length(pdfs)
       prob = prob + reshape(pdfs{k}(data), length(data), 1) * phi(k);
    end
end

