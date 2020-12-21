function powerImage = power_estimation(image) 
    
    wr = double(2.13636845e-7);
    wg = 1.77746705e-7;
    wb = 2.14348309e-7;
    gamma = 0.7755;
    w0 = 1.48169521e-6;
    
    R = double(image(:,:,1));
	G = double(image(:,:,2));
	B = double(image(:,:,3));
	powerPixel = wr*(R.^gamma) + wg*(G.^gamma) + wb*(B.^gamma);
    powerImage = w0 + sum(powerPixel, 'all');
    
end