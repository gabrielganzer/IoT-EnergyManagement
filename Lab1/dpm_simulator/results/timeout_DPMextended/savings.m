fileID = fopen('case5.txt');
C = textscan(fileID,'%d; %d; %f; %f; %f; %f');
Z = C{6};
z(1,:) = Z(1:51);
for i = 2:51
    z(i,:) = Z((51*i)-50:i*51);
end
x = 0:4:200;
y = 0:4:200;
surf(x,y,z);
xlabel('Time to Idle [us]')
ylabel('Time to Sleep [us]');
zlabel('Savings [%]');
saveas(gcf, 'surf_tri.png');