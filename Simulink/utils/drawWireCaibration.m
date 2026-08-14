clear; clc; close all

year = '2026';
projname = 'TEAMERAOELUPA9';
expname = 'DrawWireCalibration';
trialname = 'Trial03';

fname = dir(fullfile('Z:','projects',year,projname,'data','onboard',expname,trialname,'*.mat'));
load([fname.folder,'\',fname.name])

time = output.time;
dw = output.sensors.drawWire_counts;

figure
plot(time,dw)
xlabel('time(s)')
ylabel('counts')
grid on


disp_m = (0:.1:.8).';
dw_count = dw([10995 17849 22796 28952 34059 40484 45484 50457 55376])';

mdl = fitlm(dw_count,disp_m);
coefs = mdl.Coefficients.Estimate;
slope = coefs(2);
offset = coefs(1);
rSq = mdl.Rsquared.Ordinary;


x = 3.326e7:3.333e7;
y = slope*x+offset;

figure
plot(dw_count,disp_m,'*')
hold on
plot(x,y)
