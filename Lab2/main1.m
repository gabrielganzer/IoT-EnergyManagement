% Collecting images
folderMisc = image_collect('misc/', '*.tiff')';
folderTrain = image_collect('train/', '*.jpg')';
folderUser = image_collect('user/', '*.png')';
originalImages = [folderMisc; folderTrain; folderUser];

% % Evaluation of power consumption
% n = size(originalImages);
% powerOriginal = zeros(n);
% for k = 1:n(1)
%     powerOriginal(k) = power_estimation(originalImages{k});
% end
% 
% % Color manipulation
% colorImages = cell(n(1), 5);
% m = size(colorImages); 
% powerColor = zeros(m);
% savingsColor = zeros(m);
% distColor = zeros(m);
% mssimColor = zeros(m);
% for i = 1:n(1)
%     for j = 1:1:5
%         colorImages{i,j} = color_manipulation(originalImages{i}, j*10);
%         powerColor(i,j) = power_estimation(colorImages{i,j});
%         savingsColor(i,j) = ((powerOriginal(i) - powerColor(i,j)) / powerOriginal(i)) * 100;
%         distColor(i,j) = euclidean_distance(originalImages{i}, colorImages{i,j});
%         mssimColor(i,j) = ssim(originalImages{i}, colorImages{i,j})*100;
%     end
% end
% 
% % Histogram equalization
% histImages = cell(n);
% powerHist = zeros(n);
% savingsHist = zeros(n);
% distHist = zeros(n);
% mssimHist = zeros(n);
% for k = 1:n(1)
%     histImages{k} = histogram_equalization(originalImages{k});
%     powerHist(k) = power_estimation(histImages{k});
%     savingsHist(k) = ((powerOriginal(k) - powerHist(k)) / powerOriginal(k)) * 100;
%     distHist(k) = euclidean_distance(originalImages{k}, histImages{k});
%     mssimHist(k) = ssim(originalImages{k}, histImages{k})*100;
% end
% 
% % Contrast-limited adaptive histogram equalization
% adaptImages = cell(n);
% powerAdapt = zeros(n);
% savingsAdapt = zeros(n);
% distAdapt = zeros(n);
% mssimAdapt = zeros(n);
% for k = 1:n(1)
%     adaptImages{k} = adaptive_histogram_equalization(originalImages{k});
%     powerAdapt(k) = power_estimation(adaptImages{k});
%     savingsAdapt(k) = ((powerOriginal(k) - powerAdapt(k)) / powerOriginal(k)) * 100;
%     distAdapt(k) = euclidean_distance(originalImages{k}, adaptImages{k});
%     mssimAdapt(k) = ssim(originalImages{k}, adaptImages{k})*100;
% end