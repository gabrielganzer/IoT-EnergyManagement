clear
clc
close all

% Activation power results
%Parallel
figure('Renderer', 'painters', 'Position', [10 10 1400 400])
subplot(1,3,1);
hold on
grid on
load('parallel_wl.mat');
plot(3.3*loadCurrent(1:360), 'LineWidth', 1.5);
plot(battVoltage(1:360).*battCurrent(1:360), 'LineWidth', 1.5);
plot(dcToBatt(1:360), 'LineWidth', 1.5);
plot(powerToDC(1:360), 'LineWidth', 1.5);
set(gca,'FontSize',14);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Power [W]', 'FontSize', 14);
xlim([0 360]);
ylim([0 0.3]);
legend('Load', 'Battery', 'DC Conv - Battery', 'DC Conv - PV cell');
title('Parallel', 'FontSize', 14);
hold off
%Serial
subplot(1,3,2);
hold on
grid on
load('serial_wl.mat');
plot(3.3*loadCurrent(1:360), 'LineWidth', 1.5);
plot(battVoltage(1:360).*battCurrent(1:360), 'LineWidth', 1.5);
plot(dcToBatt(1:360), 'LineWidth', 1.5);
plot(powerToDC(1:360), 'LineWidth', 1.5);
set(gca,'FontSize',14);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Power [W]', 'FontSize', 14);
xlim([0 360]);
ylim([0 0.3]);
legend('Load', 'Battery', 'DC Conv - Battery', 'DC Conv - PV cell');
title('Serial', 'FontSize', 14);
hold off
%Custom
subplot(1,3,3);
hold on
grid on
load('custom_wl.mat');
plot(3.3*loadCurrent(1:360), 'LineWidth', 1.5);
plot(battVoltage(1:360).*battCurrent(1:360), 'LineWidth', 1.5);
plot(dcToBatt(1:360), 'LineWidth', 1.5);
plot(powerToDC(1:360), 'LineWidth', 1.5);
set(gca,'FontSize',14);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Power [W]', 'FontSize', 14);
xlim([0 360]);
ylim([0 0.3]);
legend('Load', 'Battery', 'DC Conv - Battery', 'DC Conv - PV cell');
title('Custom', 'FontSize', 14);
hold off
%Save
saveas(gcf, 'activation_power.png');



% Current evaluation
% Parallell
figure('Renderer', 'painters', 'Position', [10 10 1400 400])
hold on
grid on
load('parallel_wl.mat');
plot(battCurrent,'LineWidth', 0.25);
plot(PVcurrent,'LineWidth', 2);
set(gca,'FontSize',14);
ylim([-0.04 0.1]);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Current [A]', 'FontSize', 14);
legend('Battery', 'PV Cell');
hold off
saveas(gcf, 'current_parallel.png');
% Serial
figure('Renderer', 'painters', 'Position', [10 10 1400 400])
hold on
grid on
load('serial_wl.mat');
plot(battCurrent,'LineWidth', 0.25);
plot(PVcurrent,'LineWidth', 2);
set(gca,'FontSize',14);
ylim([-0.04 0.1]);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Current [A]', 'FontSize', 14);
legend('Battery', 'PV Cell');
hold off
saveas(gcf, 'current_serial.png');
% Custom
figure('Renderer', 'painters', 'Position', [10 10 1400 400])
hold on
grid on
load('custom_wl.mat');
plot(battCurrent,'LineWidth', 0.25);
plot(PVcurrent,'LineWidth', 2);
set(gca,'FontSize',14);
ylim([-0.04 0.1]);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Current [A]', 'FontSize', 14);
legend('Battery', 'PV Cell');
hold off
saveas(gcf, 'current_custom.png');

% Efficiency
load('parallel_wl.mat');
battEffP = round(mean(efficiencyBattery),4);
pvEffP = round(mean(efficiencyPV),4);
durP = size(activePV);
durP = round(durP(1,1)/(24*3600),4);
load('serial_wl.mat');
battEffS = round(mean(efficiencyBattery),4);
pvEffS = round(mean(efficiencyPV),4);
durS = size(activePV);
durS = round(durS(1,1)/(24*3600),4);
load('custom_wl.mat');
battEffC = round(mean(efficiencyBattery),4);
pvEffC = round(mean(efficiencyPV),4);
durC = size(activePV);
durC = round(durC(1,1)/(24*3600),4);
T1 = table(['P';'S';'C'],[battEffP;battEffS;battEffC],...
    [pvEffP;pvEffS;pvEffC], [durP;durS;durC]);
writetable(T1, 'efficiency.txt');

% Battery SOC w/ model improvement
figure('Renderer', 'painters', 'Position', [10 10 1400 400])
hold on
grid on
% Original
load('custom_wl.mat');
plot(battSOC,'LineWidth', 2);
battEff1 = round(mean(efficiencyBattery),4);
pvEff1 = round(mean(efficiencyPV),4);
dur1 = size(activePV);
dur1 = round(dur1(1,1)/(24*3600),4);
% 2 PV cells in parallel
load('2pv_parallel.mat');
plot(battSOC,'LineWidth', 2);
battEff2 = round(mean(efficiencyBattery),4);
pvEff2 = round(mean(efficiencyPV),4);
dur2 = size(activePV);
dur2 = round(dur2(1,1)/(24*3600),4);
% 2 PV cells in series
load('2pv_series.mat');
plot(battSOC,'LineWidth', 2);
battEff3 = round(mean(efficiencyBattery),4);
pvEff3 = round(mean(efficiencyPV),4);
dur3 = size(activePV);
dur3 = round(dur3(1,1)/(24*3600),4);
% 2 batteries in series
load('batt_series.mat');
plot(battSOC,'LineWidth', 2);
battEff4 = round(mean(efficiencyBattery),4);
pvEff4 = round(mean(efficiencyPV),4);
dur4 = size(activePV);
dur4 = round(dur4(1,1)/(24*3600),4);
% 2 PV cells in parallel + 2 batteries in series
load('parallel_series.mat');
plot(battSOC,'LineWidth', 2);
battEff5 = round(mean(efficiencyBattery),4);
pvEff5 = round(mean(efficiencyPV),4);
dur5 = size(activePV);
dur5 = round(dur5(1,1)/(24*3600),4);
% 3 PV cells in parallel
load('3pv_parallel.mat');
plot(battSOC,'LineWidth', 2);
battEff6 = round(mean(efficiencyBattery),4);
pvEff6 = round(mean(efficiencyPV),4);
dur6 = size(activePV);
dur6 = round(dur6(1,1)/(24*3600),4);
% Figure and table
set(gca,'FontSize',14);
xlabel('Time [s]', 'FontSize', 14);
ylabel('SOC [%]', 'FontSize', 14);
ylim([0 1]);
legend('Original', '2 PV cells in parallel', '2 PV cells in series',...
        '2 batteries in series', '2 PV parallel + 2 batt. series',...
        '3 PV cells in parallel', 'Location', 'southeast');
saveas(gcf, 'batt_SOC.png');
T2 = table(['s1';'s2';'s3';'s4';'s5';'s6'],...
     [battEff1;battEff2;battEff3;battEff4;battEff5;battEff6],...
     [pvEff1;pvEff2;pvEff3;pvEff4;pvEff5;pvEff6],...
     [dur1;dur2;dur3;dur4;dur5;dur6]);
writetable(T2, 'efficiency2.txt');

% Custom
figure('Renderer', 'painters', 'Position', [10 10 1400 400])
hold on
grid on
load('3pv_parallel.mat');
plot(battCurrent(1:1120083),'LineWidth', 0.25);
plot(PVcurrent(1:1120083),'LineWidth', 2);
set(gca,'FontSize',14);
ylim([-0.1 0.06]);
xlabel('Time [s]', 'FontSize', 14);
ylabel('Current [A]', 'FontSize', 14);
legend('Battery', 'PV Cell');
hold off
saveas(gcf, 'current_3pv.png');