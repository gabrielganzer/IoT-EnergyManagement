fileID = fopen('history/custom1.txt');
C = textscan(fileID, '%d; %d; %f; %f; %f; %f');
fclose(fileID);
X = C{2};
Y = C{6};
figure
hold on
bar(X,Y);
xlabel('Timeout [\mus]');
ylabel('Savings [%]');
hold off
saveas(gcf,'history/custom1.png');
Trun = C{3};
Tidle = C{4};
Tsleep = C{5};
MUrun = mean(Trun);
MUidle = mean(Tidle);
MUsleep = mean(Tsleep);
dlmwrite('transitions.txt', [MUrun MUidle MUsleep], 'delimiter', ' ', 'precision', 6, '-append');