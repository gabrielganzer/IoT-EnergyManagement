function out = displayed_image(I_cell, Vdd, mode)

SATURATED = 1;
DISTORTED = 2;

p1 =   4.251e-05;
p2 =  -3.029e-04;
p3 =   3.024e-05;
Vdd_org = 15;

I_cell_max = (p1 * Vdd * 1) + (p2 * 1) + p3;
image_RGB_max = (I_cell_max - p3)/(p1*Vdd_org+p2) * 255;

out = round((I_cell - p3)/(p1*Vdd_org+p2) * 255);

if (mode == SATURATED)
    out(find(I_cell > I_cell_max)) = image_RGB_max;

else if (mode == DISTORTED)
        out(find(I_cell > I_cell_max)) ...
        = round(255 - out(find(I_cell > I_cell_max)));
        
    end
end

end

