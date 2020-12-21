function newImage = adaptive_histogram_equalization(image)
    
    labImage = rgb2lab(image);
    L = labImage(:,:,1)/100;
    L = adapthisteq(L);
    labImage(:,:,1) = L*100;
    newImage = im2uint8(lab2rgb(labImage));
    
end