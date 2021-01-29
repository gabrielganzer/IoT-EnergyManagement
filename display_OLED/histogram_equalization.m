function newImage = histogram_equalization(image)
    
    hsvImage = rgb2hsv(image);
    newValue = histeq(hsvImage(:,:,3));
    hsvImage = cat(3, hsvImage(:,:,1), hsvImage(:,:,2), newValue);
    newImage = im2uint8(hsv2rgb(hsvImage));
    
end