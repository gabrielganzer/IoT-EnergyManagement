
% Load irradiance values
load('gmonths.mat');

% Importing digitilized curves
PV250 = importdata('PVcell/PV250.txt');
PV250(:,2) = PV250(:,2)/1000;
PV500 = importdata('PVcell/PV500.txt');
PV500(:,2) = PV500(:,2)/1000;
PV750 = importdata('PVcell/PV750.txt');
PV750(:,2) = PV750(:,2)/1000;
PV1000 = importdata('PVcell/PV1000.txt');
PV1000(:,2) = PV1000(:,2)/1000;

% Power curves
MPP250 = PV250(:,1).*PV250(:,2);
MPP500 = PV500(:,1).*PV500(:,2);
MPP750 = PV750(:,1).*PV750(:,2);
MPP1000 = PV1000(:,1).*PV1000(:,2);

% Extrapolating MPP
maxMPP250 = max(MPP250);
iV250 = find(MPP250==maxMPP250);
V250 = PV250(iV250, 1);
I250 = maxMPP250/V250;

maxMPP500 = max(MPP500);
iV500 = find(MPP500==maxMPP500);
V500 = PV500(iV500, 1);
I500 = maxMPP500/V500;

maxMPP750 = max(MPP750);
iV750 = find(MPP750==maxMPP750);
V750 = PV750(iV750, 1);
I750 = maxMPP750/V750;

maxMPP1000 = max(MPP1000);
iV1000 = find(MPP1000==maxMPP1000);
V1000 = PV1000(iV1000, 1);
I1000 = maxMPP1000/V1000;

%Populating vectors

G = [250; 500; 750; 1000];
I = [I250; I500; I750; I1000];
V = [V250; V500; V750; V1000];

% Photovoltaic DC/DC converter efficiency
PVeff = importdata('PV_DCDCconv/PVefficiency.txt');

% Battery DC/DC converter efficiency
BATTeff = importdata('Battery_DCDCconv/BATTefficiency.txt');
BATTeff(:,1) = 10.^BATTeff(:,1)/1000;

% Battery
batt1C = importdata('Battery/Batt1C.txt');
batt2C = importdata('Battery/Batt2C.txt');
SOC = 0:0.1:1;
newBatt1C = interp1(batt1C(:,1),batt1C(:,2),SOC,'linear')';
newBatt2C = interp1(batt2C(:,1),batt2C(:,2),SOC,'linear')';
curr1C = 3.25;
curr2C = 2*3.25;
R = (newBatt2C - newBatt1C)/(curr1C - curr2C);
Voc = newBatt2C + R.*curr2C;


