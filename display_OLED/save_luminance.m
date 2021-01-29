orgHSV = rgb2hsv(originalImages{2});
y1 = mean(orgHSV(:,:,3));
brightHSV = rgb2hsv(brightImages{1,3});
y2 = mean(brightHSV(:,:,3));
contrastHSV = rgb2hsv(contrastImages{1,3});
y3 = mean(contrastHSV(:,:,3));
concurrentHSV = rgb2hsv(concurrentImages{1,3});
y4 = mean(concurrentHSV(:,:,3));
figure;
hold on;
axis([0 255 0 1]);
plot(y1,'LineWidth',1);
plot(y2,'LineWidth',1);
plot(y3,'LineWidth',1);
plot(y4,'LineWidth',1);
hold off;
figure
plot(y1,y2);