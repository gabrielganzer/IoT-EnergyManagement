function newImage = hybrid_technique(image, rate)
    
    hsvImage = rgb2hsv(image);
    newValue = histeq(hsvImage(:,:,3));
    hsvImage = im2uint8(hsv2rgb(cat(3, hsvImage(:,:,1), hsvImage(:,:,2), newValue)));
    reducedRed = hsvImage(:,:,1)-((rate*255)/100);
    reducedGreen = hsvImage(:,:,2)-((rate*255)/100);
    reducedBlue = hsvImage(:,:,3)-((rate*255)/100);
    newImage = cat(3, reducedRed, reducedGreen, reducedBlue);
    
end