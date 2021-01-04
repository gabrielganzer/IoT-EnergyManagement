A{1} = idle_high;
A{2} = idle_low;
A{3} = idle_exp;
A{4} = idle_normal;
A{5} = idle_tri;
idx = randperm(5);
seed = cell2mat(A(idx));
histogram(seed);

x = seed(1:125000-2)';
y = seed(2:125000-1)';
z = seed(3:125000)';
[P, S] = polyfit([x y],[z y], 2);
[Y,DELTA] = polyval(P,x,S);
error = mean(DELTA);
