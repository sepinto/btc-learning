[pe, pdf_expmixture] = fitExponential(y');

figure; hold;
edges = 1:20:5000;
histogram(y', edges, 'Normalization', 'pdf');
x = 1:5000;
plot(x, pdf_expmixture(x, pe(1), pe(2), pe(3)), 'LineWidth', 2);
