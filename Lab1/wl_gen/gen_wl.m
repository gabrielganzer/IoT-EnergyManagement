% No. of samples
samples = 5000;

% Active: uniform dist (max = 1us, max = 500us)
pdf1 = makedist('Uniform', 'Lower', 1, 'Upper', 500);
active = zeros(1, samples);
for i = 1:samples
    active(i) = floor(random(pdf1));
end
histogram(active, 'BinMethod', 'integers', 'Normalization', 'pdf');
saveas(gcf,'Active.png');

% Idle High: uniform dist (max = 1us, max = 100us)
pdf2 = makedist('Uniform', 'Lower', 1, 'Upper', 100);
idle_high = zeros(1, samples);
for i = 1:samples
    idle_high(i) = floor(random(pdf2));
end
histogram(idle_high, 'BinMethod', 'integers', 'Normalization', 'pdf');
saveas(gcf,'Idle_High.png');
save_wl(active,idle_high,'wl_high.txt', samples);

% Idle Low: uniform dist (max = 1us, max = 400us)
pdf3 = makedist('Uniform', 'Lower', 1, 'Upper', 400);
idle_low = zeros(1, samples);
for i = 1:samples
    idle_low(i) = floor(random(pdf3));
end
histogram(idle_low, 'BinMethod', 'integers', 'Normalization', 'pdf');
saveas(gcf,'Idle_Low.png');
save_wl(active,idle_low,'wl_low.txt', samples);

% Idle Normal: normal dist (mu = 100us, sigma = 20)
pdf4 = makedist('Normal', 'mu', 100, 'sigma', 20);
idle_normal = zeros(1, samples);
for i = 1:samples
    idle_normal(i) = floor(random(pdf4));
end
histogram(idle_normal, 'BinMethod', 'integers', 'Normalization', 'pdf');
saveas(gcf,'Idle_Normal.png');
save_wl(active,idle_normal,'wl_normal.txt', samples);

% Idle Exponetial: exponential dist (mu = 50us)
pdf5 = makedist('Exponential', 'mu', 50);
idle_exp = zeros(1, samples);
for i = 1:samples
    idle_exp(i) = floor(random(pdf5));
end
histogram(idle_exp, 'BinMethod', 'integers', 'Normalization', 'pdf');
saveas(gcf,'Idle_Exp.png');
save_wl(active,idle_exp,'wl_exp.txt', samples);

% Idle tri-modal: tri-modal dist (mu = 50us, 100us, 150us; sigma = 10)
pd1 = makedist('Normal', 'mu', 50, 'sigma', 10);
pd2 = makedist('Normal', 'mu', 100, 'sigma', 10);
pd3 = makedist('Normal', 'mu', 150, 'sigma', 10);
idle_tri = zeros(1, samples);
for i = 1:samples
    res = mod(i, 3);
    if res == 0
        idle_tri(i) = floor(random(pd1));
    elseif res == 1
        idle_tri(i) = floor(random(pd2));
    elseif res == 2
        idle_tri(i) = floor(random(pd3));
    end
end
histogram(idle_tri, 'BinMethod', 'integers', 'Normalization', 'pdf');
saveas(gcf,'Idle_Tri.png');
save_wl(active, idle_tri, 'wl_tri.txt', samples);