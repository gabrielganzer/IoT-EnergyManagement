function Ppanel = power_consumption(Vdd, Icell)

n = size(Icell);
Ipanel = 0;
for i = n(1)
    for j = n(2)
        Ipanel = Ipanel + Icell(i,j);
    end
end

Ppanel = Vdd*Ipanel;

end