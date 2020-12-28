function newImg = brightness_compensantion(img, VddOrg,VddNew)

    hsvImg = rgb2hsv(img);
    b = (VddOrg-VddNew)/VddOrg;
    V = hsvImg(:,:,3);
    n = size(V);
    newV = zeros(n);
    for i = 1:n(1)
        for j = 1:n(2)
            newV(i,j) = min(1, V(i,j)+b);
            %newV(i,j) = V(i,j)+b;
        end
    end
    
    newImg = im2uint8(hsv2rgb(cat(3, hsvImg(:,:,1), hsvImg(:,:,2), newV)));
    
end