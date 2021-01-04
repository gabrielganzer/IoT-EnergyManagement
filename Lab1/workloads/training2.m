% Random distribution
pdf1 = makedist('Exponential', 'mu', 25);
pdf2 = makedist('Uniform', 'Lower', 1, 'Upper', 50);
pdf3 = makedist('Uniform', 'Lower', 1, 'Upper', 75);
pdf4 = makedist('Uniform', 'Lower', 1, 'Upper', 100);
pdf5 = makedist('Normal', 'mu',100, 'sigma', 25);
pdf6 = makedist('Weibull','a',150,'b', 5);
pdf7 = makedist('Normal', 'mu',200, 'sigma', 25);
pdf8 = makedist('Uniform', 'Lower', 200, 'Upper', 400);
pdf9 = makedist('Normal', 'mu',400, 'sigma', 25);
pdf10 = makedist('Normal', 'mu',500, 'sigma', 25);
X = zeros(1, 250000);
for i = 1:250000
    if i <= 25000
        X(i) = floor(random(pdf1));
    elseif i>25000 && i<=50000
        X(i) = floor(random(pdf2));
    elseif i>50000 && i<=75000
        X(i) = floor(random(pdf3));
    elseif i>75000 && i<=100000
        X(i) = floor(random(pdf4));
    elseif i>100000 && i<=125000
        X(i) = floor(random(pdf5));
    elseif i>125000 && i<=150000
        X(i) = floor(random(pdf6));
    elseif i>150000 && i<=175000
        X(i) = floor(random(pdf7));
    elseif i>175000 && i<=200000
        X(i) = floor(random(pdf8));
    elseif i>200000 && i<=225000
        X(i) = floor(random(pdf9));
    else
        X(i) = floor(random(pdf10));
    end
end
histogram(X);
x = X(1:250000-2)';
y = X(2:250000-1)';
z = X(3:250000)';
[P, S] = polyfit([x,z],[y,z],2);
[Y,DELTA] = polyval(P,x,S);
error = mean(DELTA);