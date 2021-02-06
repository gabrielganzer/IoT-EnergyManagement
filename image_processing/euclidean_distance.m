function distortion = euclidean_distance(imageI, imageJ)
    
    labImageI = rgb2lab(imageI);
    labImageJ = rgb2lab(imageJ);
    
    LI = labImageI(:,:,1);
    aI = labImageI(:,:,2);
    bI = labImageI(:,:,3);
    
    LJ = labImageJ(:,:,1);
    aJ = labImageJ(:,:,2);
    bJ = labImageJ(:,:,3);
    
    n = size(labImageI);
    m = size(labImageJ);
    
    partial = sqrt((LI-LJ).^2 + (aI-aJ).^2 + (bI-bJ).^2);
    epsilon = sum(partial, 'all');
    
    distortion = (epsilon/(n(1)*m(2)*sqrt(100^2 + 255^2 + 255^2)) )*100;
    
end