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
        colorImages{i,j} = color_manipulation(originalImages{i}, 5*j);
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

Hybrid histogram equalization and color reduction
hybridImages = cell(n(1), 5);
m = size(hybridImages); 
powerHybrid = zeros(m);
savingsHybrid = zeros(m);
distHybrid = zeros(m);
mssimHybrid = zeros(m);
for i = 1:n(1)
    for j = 1:1:5
        hybridImages{i,j} = hybrid_technique(originalImages{i}, (15/4)*j+5/4);
        powerHybrid(i,j) = power_estimation(hybridImages{i,j});
        savingsHybrid(i,j) = ((powerOriginal(i) - powerHybrid(i,j)) / powerOriginal(i)) * 100;
        distHybrid(i,j) = euclidean_distance(originalImages{i}, hybridImages{i,j});
        mssimHybrid(i,j) = ssim(originalImages{i}, hybridImages{i,j})*100;
    end
end

% Color reduction analysis
idx = 10;
figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,6,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+powerOriginal(idx)+"W")},'FontSize',14);
for i = 1:1:5
    subplot(1,6,i+1);
    imshow(colorImages{idx,i});
    xlabel({(5*i+"% Color Reduction");...
        ("ɛ = "+distColor(idx,i));...
        ("MSSIM = "+mssimColor(idx,i));...
        ("Savings = "+savingsColor(idx,i))},'FontSize',14);
end
saveas(gcf, 'colorComp.png');

varName = {'Color reduction [%],', 'Savings [%],', 'Distortion [%],', 'MSSIM [%],'};
T1 = table([5;10;15;20;25],...
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

% Adaptive equalization analysis
img = adaptImages{idx};
title = [("ɛ = "+distAdapt(idx));...
        ("MSSIM = "+mssimAdapt(idx));...
        ("Savings = "+savingsAdapt(idx))];
filename = 'afterAdaptive.png';
save_hist(img, title, filename);

figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,3,1);
hold on;
histogram(savingsHist);
histogram(savingsAdapt);
ylim([0, 100]);
legend('Hist. Eq.', 'Adaptive Eq.', 'Location', 'northwest');
hold off;
xlabel('Savings [%]','FontSize',14);
subplot(1,3,2);
hold on;
histogram(distHist);
histogram(distAdapt);
ylim([0, 100]);
legend('Hist. Eq.', 'Adaptive Eq.', 'Location', 'northwest');
hold off;
xlabel('Distortion [%] = Euclidean Distance','FontSize',14);
subplot(1,3,3);
hold on;
histogram(mssimHist);
histogram(mssimAdapt);
ylim([0, 100]);
legend('Hist. Eq.', 'Adaptive Eq.', 'Location', 'northwest');
hold off;
xlabel('Similarity [%] = MSSIM','FontSize',14);
saveas(gcf, 'histEqs.png');

% Hybrid technique analysis
idx = 10;
figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
subplot(1,6,1);
imshow(originalImages{idx});
xlabel({'Original';("P = "+powerOriginal(idx)+"W")},'FontSize', 14);
for i = 1:1:5
    subplot(1,6,i+1);
    imshow(hybridImages{idx,i});
    xlabel({(5*i+"% Color Reduction");...
        ("ɛ = "+distHybrid(idx,i));...
        ("MSSIM = "+mssimHybrid(idx,i));...
        ("Savings = "+savingsHybrid(idx,i))},'FontSize',14);
end
saveas(gcf, 'hybridComp.png');

varName = {'Color reduction [%],', 'Savings [%],', 'Distortion [%],', 'MSSIM [%],'};
T2 = table([5;10;15;20;25],...
          [savingsHybrid(idx,1);savingsHybrid(idx,2);savingsHybrid(idx,3);savingsHybrid(idx,4);savingsHybrid(idx,5)],...
          [distHybrid(idx,1);distHybrid(idx,2);distHybrid(idx,3);distHybrid(idx,4);distHybrid(idx,5)],...
          [mssimHybrid(idx,1);mssimHybrid(idx,2);mssimHybrid(idx,3);mssimHybrid(idx,4);mssimHybrid(idx,5)],...
          'VariableNames', varName);
writetable(T2, 'hybridReduction.txt');
