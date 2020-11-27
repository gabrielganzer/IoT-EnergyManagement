% Active: uniform dist (max = 1us, max = 500us)
sample = zeros(1, 5000);
for i = 1:5000
    sample(i) = floor(random(pdf2));
end

x = sample(1:5000-1)';
y = sample(2:5000)';
[P,S,MU] = polyfit(x,y,2);