function newImage = color_manipulation(image, rate)
    
    reducedRed = image(:,:,1)-((rate*255)/100);
    reducedBlue = image(:,:,3)-((rate*255)/100);
    newImage = cat(3, reducedRed, image(:,:,2), reducedBlue);
    
end