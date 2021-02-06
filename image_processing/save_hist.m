function save_hist(img, title, filename)
    
    figure('Renderer', 'painters', 'Position', [10 10 1400 400]);
    subplot(1,3,1);
    imshow(img);
    xlabel(title,'FontSize',16);
    subplot(1,3,2);
    imhist(img);
    subplot(1,3,3);
    hist(:,1) = imhist(img(:, :, 1), 256); %RED
    hist(:,2) = imhist(img(:, :, 2), 256); %GREEN
    hist(:,3) = imhist(img(:, :, 3), 256); %BLUE
    hold on
    bar(hist(:,1), 'FaceColor', [1 0 0]);
    bar(hist(:,2), 'FaceColor', [0 1 0]);
    bar(hist(:,3), 'FaceColor', [0 0 1]);
    saveas(gcf, filename);
    
end