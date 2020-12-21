% Weibull distribution

%pdf = makedist('Weibull','a',400,'b', 10);
pdf = makedist('Weibull','a',125,'b', 2);
X = zeros(1, 25000);
for i = 1:25000
    X(i) = floor(random(pdf));
end
histogram(X);

x = X(1:25000-1)';
y = X(2:25000)';
[P, S] = polyfit(x,y,2);
[Y,DELTA] = polyval(P,x,S);
error = mean(DELTA);