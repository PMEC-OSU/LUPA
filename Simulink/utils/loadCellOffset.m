clear; clc; close all
%% Choose experiment name and trialnumber for quicklook
expname = 'LoadCellOffset';
trialnum = 2;



%% load data
trialname = ['Trial',num2str(trialnum,'%02d')];
trialdir = fullfile('Z:\projects\2022\DryLUPA\data\raw',expname,trialname);
dircontents = dir(trialdir);
filename = dircontents(3).name;
load([trialdir,'\',filename])

dt = output.LUPAinput.time(2) - output.LUPAinput.time(1);



%% plot stringpots
figure
subplot(211)
plot(output.ShoreADC.time,output.ShoreADC.sp1)
hold on
plot(output.ShoreADC.time,output.ShoreADC.sp2)
legend('Bottom Stringpot','Top Stringpot')
ylabel('displacement (m)')
grid on

%% plot load cells
subplot(212)
plot(output.LUPAinput.time,output.LUPAinput.LCbot)
hold on
plot(output.LUPAinput.time,output.LUPAinput.LCtop)

plot(output.LUPAinput.time(5./dt:end),output.LUPAinput.LCbot(5./dt:end))
plot(output.LUPAinput.time(5./dt:end),output.LUPAinput.LCtop(5./dt:end))

legend('Bottom Load Cell','Top Load Cell')
xlabel('time (s)')
ylabel('F(N)')
grid on



BotLCmean = mean(output.LUPAinput.LCbot(5./dt:end));
TopLCmean = mean(output.LUPAinput.LCtop(5./dt:end));
difference = BotLCmean-TopLCmean;



