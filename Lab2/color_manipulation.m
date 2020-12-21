function newImage = color_manipulation(image, rate)
    
    reduction = image(:,:,3)-((rate*255)/100);
    newImage = cat(3, image(:,:,1), image(:,:,2), reduction);
    
end