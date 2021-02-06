function newImg = concurrent_compensation(img, VddOrg,VddNew)

    hsvImg = rgb2hsv(img);
    gl = (VddOrg-VddNew)/VddOrg;
    gu = VddNew/VddOrg;
    c = 1/(gu-gl);
    d = -gl/(gu-gl);
    V = hsvImg(:,:,3);
    n = size(V);
    newV = zeros(n);
    for i = 1:n(1)
        for j = 1:n(2)
            if V(i,j) >= 0 && V(i,j) < gl
                newV(i,j) = 0;
            elseif V(i,j) >= gl && V(i,j) <= gu
                newV(i,j) = c*V(i,j)+d;
            else
                newV(i,j) = 1;
            end
        end
    end
    
    newImg = im2uint8(hsv2rgb(cat(3, hsvImg(:,:,1), hsvImg(:,:,2), newV)));
    
end