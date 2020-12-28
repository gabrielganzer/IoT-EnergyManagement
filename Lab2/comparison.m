
subplot(2,2,1)
histogram(satMSSIM);
xlabel('Saturated Images');
subplot(2,2,2)
histogram(brightMSSIM);
xlabel('Brightness Compensation');
subplot(2,2,3)
histogram(contrastMSSIM);
xlabel('Contrast Enhancement');
subplot(2,2,4)
histogram(concurrentMSSIM);
xlabel('Concurrent Brightness&Contrast Compensation');
saveas(gcf, 'mssimDVS.png')
