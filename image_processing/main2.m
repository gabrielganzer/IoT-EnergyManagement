% Constants
Vdd = 15;
SATURATED = 1;

% Collecting images
folderMisc = image_collect('misc/', '*.tiff')';
folderTrain = image_collect('train/', '*.jpg')';
folderUser = image_collect('user/', '*.png')';
originalImages = [folderMisc; folderTrain; folderUser];

% Extract cell current samples
n = size(originalImages);
Icell = cell(n);
for k = 1:n(1)
    Icell{k} = cell_current(originalImages{k});
end

% Power consumption
Ppanel = zeros(n);
for k = 1:n(1)
    Ppanel(k) = power_consumption(Vdd, Icell{k});
end

% Applying DVS to original images
satImages = cell(n(1),5);
satPower = zeros(n(1),5);
satDist = zeros(n(1),5);
satMSSIM = zeros(n(1),5);
satSavings = zeros(n(1),5);
for i = 1:n(1)
    for j = 1:1:5
        satImages{i,j} = im2uint8(displayed_image(Icell{i}, (((1/20)*j)+(7/10))*Vdd, SATURATED)/255);
        satPower(i,j) = power_consumption((((1/20)*j)+(7/10))*Vdd, cell_current(satImages{i,j}));
        satDist(i,j) = euclidean_distance(originalImages{i}, satImages{i,j});
        satMSSIM(i,j) = ssim(originalImages{i}, satImages{i,j})*100;
        satSavings(i,j) = ((Ppanel(i) - satPower(i,j))/Ppanel(i))*100;
    end
end

% Brightness compensation
brightImages = cell(n(1),5);
brightDisplay = cell(n(1),5);
brightPower = zeros(n(1),5);
brightDist = zeros(n(1),5);
brightMSSIM = zeros(n(1),5);
brightSavings = zeros(n(1),5);

for i = 1:n(1)
    for j = 1:1:5
        brightImages{i,j} = brightness_compensantion(originalImages{i}, Vdd, (((1/20)*j)+(7/10))*Vdd);
        brightDisplay{i,j} = im2uint8(displayed_image(cell_current(brightImages{i,j}), (((1/20)*j)+(7/10))*Vdd, SATURATED)/255);
        brightPower(i,j) = power_consumption((((1/20)*j)+(7/10))*Vdd, cell_current(brightDisplay{i,j}));
        brightDist(i,j) = euclidean_distance(originalImages{i}, brightDisplay{i,j});
        brightMSSIM(i,j) = ssim(originalImages{i}, brightDisplay{i,j})*100;
        brightSavings(i,j) = ((Ppanel(i) - brightPower(i,j))/Ppanel(i))*100;
    end
end

% Contrast enhancement
contrastImages = cell(n(1),5);
contrastDisplay = cell(n(1),5);
contrastPower = zeros(n(1),5);
contrastDist = zeros(n(1),5);
contrastMSSIM = zeros(n(1),5);
contrastSavings = zeros(n(1),5);

for i = 1:n(1)
    for j = 1:1:5
        contrastImages{i,j} = contrast_enhancement(originalImages{i}, Vdd, (((1/20)*j)+(7/10))*Vdd);
        contrastDisplay{i,j} = im2uint8(displayed_image(cell_current(contrastImages{i,j}), (((1/20)*j)+(7/10))*Vdd, SATURATED)/255);
        contrastPower(i,j) = power_consumption((((1/20)*j)+(7/10))*Vdd, cell_current(contrastDisplay{i,j}));
        contrastDist(i,j) = euclidean_distance(originalImages{i}, contrastDisplay{i,j});
        contrastMSSIM(i,j) = ssim(originalImages{i}, contrastDisplay{i,j})*100;
        contrastSavings(i,j) = ((Ppanel(i) - contrastPower(i,j))/Ppanel(i))*100;
    end
end
 
% Concurrent brightness compensation and contrast enhancement
concurrentImages = cell(n(1),5);
concurrentDisplay = cell(n(1),5);
concurrentPower = zeros(n(1),5);
concurrentDist = zeros(n(1),5);
concurrentMSSIM = zeros(n(1),5);
concurrentSavings = zeros(n(1),5);

for i = 1:n(1)
    for j = 1:1:5
        concurrentImages{i,j} = concurrent_compensation(originalImages{i}, Vdd, (((1/20)*j)+(7/10))*Vdd);
        concurrentDisplay{i,j} = im2uint8(displayed_image(cell_current(concurrentImages{i,j}), (((1/20)*j)+(7/10))*Vdd, SATURATED)/255);
        concurrentPower(i,j) = power_consumption((((1/20)*j)+(7/10))*Vdd, cell_current(concurrentDisplay{i,j}));
        concurrentDist(i,j) = euclidean_distance(originalImages{i}, concurrentDisplay{i,j});
        concurrentMSSIM(i,j) = ssim(originalImages{i}, concurrentDisplay{i,j})*100;
        concurrentSavings(i,j) = ((Ppanel(i) - concurrentPower(i,j))/Ppanel(i))*100;
    end
end

%Saturated images analysis
idx = 4;
figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,6,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+Ppanel(idx)+"W")},'FontSize',14);
for i = 1:1:5
    subplot(1,6,i+1);
    imshow(satImages{idx,6-i});
    xlabel({("DVS("+(100-i*5)+"%)");...
        ("ɛ = "+satDist(idx,6-i));...
        ("MSSIM = "+satMSSIM(idx,6-i));...
        ("Savings = "+satSavings(idx,6-i))},'FontSize',14);
end
saveas(gcf, 'saturatedDVS.png');

%Brightness analysis
idx = 4;
figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,6,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+Ppanel(idx)+"W")},'FontSize',14);
for i = 1:1:5
    subplot(1,6,i+1);
    imshow(brightImages{idx,6-i});
    xlabel({("DVS("+(100-i*5)+"%)");...
        ("ɛ = "+brightDist(idx,6-i));...
        ("MSSIM = "+brightMSSIM(idx,6-i));...
        ("Savings = "+brightSavings(idx,6-i))},'FontSize',14);
end
saveas(gcf, 'brightDVS.png');

%Constrast analysis
idx = 4;
figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,6,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+Ppanel(idx)+"W")},'FontSize',14);
for i = 1:1:5
    subplot(1,6,i+1);
    imshow(contrastImages{idx,6-i});
    xlabel({("DVS("+(100-i*5)+"%)");...
        ("ɛ = "+contrastDist(idx,6-i));...
        ("MSSIM = "+contrastMSSIM(idx,6-i));...
        ("Savings = "+contrastSavings(idx,6-i))},'FontSize',14);
end
saveas(gcf, 'contrastDVS.png');

%Concurrent analysis
idx = 4;
figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,6,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+Ppanel(idx)+"W")},'FontSize',14);
for i = 1:1:5
    subplot(1,6,i+1);
    imshow(concurrentImages{idx,6-i});
    xlabel({("DVS("+(100-i*5)+"%)");...
        ("ɛ = "+concurrentDist(idx,6-i));...
        ("MSSIM = "+concurrentMSSIM(idx,6-i));...
        ("Savings = "+concurrentSavings(idx,6-i))},'FontSize',14);
end
saveas(gcf, 'concurrentDVS.png');

%Overall results
T1 = fill_table(satDist, brightDist, contrastDist, concurrentDist);
writetable(T1, 'overallDist.txt');
T2 = fill_table(satMSSIM, brightMSSIM, contrastMSSIM, concurrentMSSIM);
writetable(T2, 'overallMSSIM.txt');
T3 = fill_table(satPower, brightPower, contrastPower, concurrentPower);
writetable(T3, 'overallPower.txt');
T4 = fill_table(satSavings, brightSavings, contrastSavings, concurrentSavings);
writetable(T4, 'overallMSSIM.txt');

figure;
hold on;
subplot(2,2,1);
histogram(satDist);
xlabel('Saturated Images','FontSize',14);
subplot(2,2,2);
histogram(brightDist);
xlabel('Brightness Compensation','FontSize',14);
subplot(2,2,3);
histogram(contrastDist);
xlabel('Contrast Enhancement','FontSize',14);
subplot(2,2,4);
histogram(concurrentDist);
xlabel('Concurrent Compensation','FontSize',14);
hold off;
saveas(gcf, 'distDVS.png');

figure;
hold on;
subplot(2,2,1);
histogram(satMSSIM);
xlabel('Saturated Images','FontSize',14);
subplot(2,2,2);
histogram(brightMSSIM);
xlabel('Brightness Compensation','FontSize',14);
subplot(2,2,3);
histogram(contrastMSSIM);
xlabel('Contrast Enhancement','FontSize',14);
subplot(2,2,4);
histogram(concurrentMSSIM);
xlabel('Concurrent Compensation','FontSize',14);
hold off;
saveas(gcf, 'mssimDVS.png');

figure;
hold on;
subplot(2,2,1);
histogram(satSavings);
xlabel('Saturated Images','FontSize',14);
subplot(2,2,2);
histogram(brightSavings);
xlabel('Brightness Compensation','FontSize',14);
subplot(2,2,3);
histogram(contrastSavings);
xlabel('Contrast Enhancement','FontSize',14);
subplot(2,2,4);
histogram(concurrentSavings);
xlabel('Concurrent Compensation','FontSize',14);
hold off;
saveas(gcf, 'savingsDVS.png');

idx = 34;
originalImagesHSV = rgb2hsv(originalImages{idx});
brightImagesHSV = rgb2hsv(brightImages{idx});
contrastImagesHSV = rgb2hsv(contrastImages{idx});
concurrentImagesHSV = rgb2hsv(concurrentImages{idx});

orgV = mean(originalImagesHSV(:,:,3));
brightV = mean(brightImagesHSV(:,:,3));
contrastV = mean(contrastImagesHSV(:,:,3));
concurrentV = mean(concurrentImagesHSV(:,:,3));

figure;
hold on;
subplot(2,2,1);
imshow(originalImages{idx});
xlabel('Saturated Image','FontSize',14);
subplot(2,2,2);
imshow(brightImages{idx});
xlabel({('Brightness Compensation');("Savings = "+brightSavings(idx))},'FontSize',14);
subplot(2,2,3);
imshow(contrastImages{idx});
xlabel({('Contrast Enhancement');("Savings = "+contrastSavings(idx))},'FontSize',14);
subplot(2,2,4);
imshow(concurrentImages{idx});
xlabel({('Concurrent Compensation');("Savings = "+concurrentSavings(idx))},'FontSize',14);
hold off;
saveas(gcf, 'sample.png');

figure;
hold on;
grid on;
plot(orgV,'LineWidth',1.5);
plot(brightV,'LineWidth',1.5);
plot(contrastV,'LineWidth',1.5);
plot(concurrentV,'LineWidth',1.5);
ylabel('Average Value','FontSize',14);
xlabel('Pixel line','FontSize',14);
title('DVS[85%]','FontSize',14);
ylim([0.3 1]);
xlim([0 482]);
legend('Original', 'Brightness', 'Contrast','Concurrent');
hold off;
saveas(gcf, 'luminance.png');


