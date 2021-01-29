% Mix all the samples randomly
A{1} = idle_high;
A{2} = idle_low;
A{3} = idle_exp;
A{4} = idle_normal;
A{5} = idle_tri;
idx = randperm(5);
seed = cell2mat(A(idx));

% Find the polynomial
x = seed(1:samples-2)';
y = seed(2:samples-1)';
z = seed(3:samples)';
[P, S] = polyfit([x y],[z y], 2);
[Y,DELTA] = polyval(P,x,S);
error = mean(DELTA);

% Save results
histogram(seed);
saveas(gcf,'training1.png');
T = table(['p1'; 'p2'; 'p3'; 'er'],[P(1); P(2); P(3); error;]);
writetable(T, 'coefficients1.txt');