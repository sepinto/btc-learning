function [ out ] = plotHistogram( data, fignum )

figure(fignum(1))
clf
histogram(data,histEdges(data,10000));

title('Histogram of Collected UTXO Lifespan Data', 'fontsize',30,'fontweight','normal')
xlabel('Hours', 'fontsize',30,'fontweight','normal')
set(gca,'fontsize',30) 

figure(fignum(2))
clf
histogram(data,histEdges(data,10000));

axis([0 800 0 600])
xlabel('Hours', 'fontsize',20,'fontweight','normal')
set(gca,'fontsize',20) 

figure(fignum(3))
clf
histogram(data,histEdges(data,10000));

axis([2500 20000 0 5])
xlabel('Hours', 'fontsize',20,'fontweight','normal')
set(gca,'fontsize',20) 



end

