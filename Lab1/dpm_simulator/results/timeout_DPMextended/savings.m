fileID = fopen('../case1.txt');
C = textscan(fileID,'%d; %d; %d; %f');
X = C{2};
Y = C{4};
figure
hold on
bar(X,Y);
title('Custom workload 2 - Timeout @ 80 \mus');
xlabel('Time to sleep [\mus]');
ylabel('Savings [%]');
hold off