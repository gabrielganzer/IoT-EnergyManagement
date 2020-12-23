function Icell = cell_current(img)

p1 = 4.251e-05;
p2 = -3.029e-04;
p3 = 3.024e-05;
Vdd = 15; 

Icell = ((p1*Vdd*double(img))/255) + ((p2*double(img))/255) + p3;

end