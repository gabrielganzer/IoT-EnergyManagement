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