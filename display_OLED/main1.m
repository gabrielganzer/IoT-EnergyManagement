% Collecting images
folderMisc = image_collect('misc/', '*.tiff')';
folderTrain = image_collect('train/', '*.jpg')';
folderUser = image_collect('user/', '*.png')';
originalImages = [folderMisc; folderTrain; folderUser];

% Evaluation of power consumption
n = size(originalImages);
powerOriginal = zeros(n);
for k = 1:n(1)
    powerOriginal(k) = power_estimation(originalImages{k});
end

% Color manipulation
colorImages = cell(n(1), 5);
m = size(colorImages); 
powerColor = zeros(m);
savingsColor = zeros(m);
distColor = zeros(m);
mssimColor = zeros(m);
for i = 1:n(1)
    for j = 1:1:5
        colorImages{i,j} = color_manipulation(originalImages{i}, j*10);
        powerColor(i,j) = power_estimation(colorImages{i,j});
        savingsColor(i,j) = ((powerOriginal(i) - powerColor(i,j)) / powerOriginal(i)) * 100;
        distColor(i,j) = euclidean_distance(originalImages{i}, colorImages{i,j});
        mssimColor(i,j) = ssim(originalImages{i}, colorImages{i,j})*100;
    end
end

% Histogram equalization
histImages = cell(n);
powerHist = zeros(n);
savingsHist = zeros(n);
distHist = zeros(n);
mssimHist = zeros(n);
for k = 1:n(1)
    histImages{k} = histogram_equalization(originalImages{k});
    powerHist(k) = power_estimation(histImages{k});
    savingsHist(k) = ((powerOriginal(k) - powerHist(k)) / powerOriginal(k)) * 100;
    distHist(k) = euclidean_distance(originalImages{k}, histImages{k});
    mssimHist(k) = ssim(originalImages{k}, histImages{k})*100;
end

% Contrast-limited adaptive histogram equalization
adaptImages = cell(n);
powerAdapt = zeros(n);
savingsAdapt = zeros(n);
distAdapt = zeros(n);
mssimAdapt = zeros(n);
for k = 1:n(1)
    adaptImages{k} = adaptive_histogram_equalization(originalImages{k});
    powerAdapt(k) = power_estimation(adaptImages{k});
    savingsAdapt(k) = ((powerOriginal(k) - powerAdapt(k)) / powerOriginal(k)) * 100;
    distAdapt(k) = euclidean_distance(originalImages{k}, adaptImages{k});
    mssimAdapt(k) = ssim(originalImages{k}, adaptImages{k})*100;
end

% Color reduction analysis
idx = 10;
subplot(2,3,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+powerOriginal(idx)+"W")});
for i = 1:1:5
    subplot(2,3,i+1);
    imshow(colorImages{idx,i});
    xlabel({(i*10+"% Color Reduction");...
        ("ɛ = "+distColor(idx,i));...
        ("MSSIM = "+mssimColor(idx,i));...
        ("Savings = "+savingsColor(idx,i))});
end
saveas(gcf, 'colorComp.png');

varName = {'Color reduction [%],', 'Savings [%],', 'Distortion [%],', 'MSSIM [%],'};
T1 = table([10;20;30;40;50],...
          [savingsColor(idx,1);savingsColor(idx,2);savingsColor(idx,3);savingsColor(idx,4);savingsColor(idx,5)],...
          [distColor(idx,1);distColor(idx,2);distColor(idx,3);distColor(idx,4);distColor(idx,5)],...
          [mssimColor(idx,1);mssimColor(idx,2);mssimColor(idx,3);mssimColor(idx,4);mssimColor(idx,5)],...
          'VariableNames', varName);
writetable(T1, 'colorReduction.txt');

% Histogram equalization analysis
idx = 25;
img = originalImages{idx};
title = 'Original';
filename = 'beforeEqualization.png';
save_hist(img, title, filename);

img = histImages{idx};
title = [("ɛ = "+distHist(idx));...
        ("MSSIM = "+mssimHist(idx));...
        ("Savings = "+savingsHist(idx))];
filename = 'afterEqualization.png';
save_hist(img, title, filename);

figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,3,1);
histogram(savingsHist);
xlabel('Savings [%]');
subplot(1,3,2);
histogram(distHist);
xlabel('Distortion [%] = Euclidean Distance');
subplot(1,3,3);
histogram(mssimHist);
xlabel('Similarity [%] = MSSIM');
saveas(gcf, 'resultsHistEq.png');

% Adaptive equalization analysis
img = adaptImages{idx};
title = [("ɛ = "+distAdapt(idx));...
        ("MSSIM = "+mssimAdapt(idx));...
        ("Savings = "+savingsAdapt(idx))];
filename = 'afterAdaptive.png';
save_hist(img, title, filename);

figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,3,1);
histogram(savingsAdapt);
xlabel('Savings [%]');
subplot(1,3,2);
histogram(distAdapt);
xlabel('Distortion [%] = Euclidean Distance');
subplot(1,3,3);
histogram(mssimAdapt);
xlabel('Similarity [%] = MSSIM');
saveas(gcf, 'resultsAdaptEq.png');
