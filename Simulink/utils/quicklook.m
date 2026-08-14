clear; clc; close all
%% Choose experiment name and trialnumber for quicklook
expname = 'DAQTest';
trialnum = 1;

%% load data
trialname = ['Trial',num2str(trialnum,'%02d')];
trialdir = fullfile('Z:\projects\2023\TEAMERLUPA2\data\onboard',expname,trialname);
dircontents = dir(trialdir);
filename = dircontents(4).name;
load([trialdir,'\',filename])

figure
plot(diff(output.timestamp.timestamp))
xlabel('samples')
ylabel('period (s)')
title('\Delta t variations')

%% plot torque data
figure
plot(output.time,output.ELMO.torque_Nm)
hold on
plot(output.time,output.control.target_A*7.86)
xlabel('time (s)')
ylabel('Torque (Nm)')
legend('Drive reported','command signal')
grid on
title('Motor Torque')

%% rotary to linear conversion
% pulleyradius = 0.0407416;   % 32 tooth pulley
% pulleyradius = 0.0636651;   % 50 tooth pulley
pulleyradius = 0.101854;   % 80 tooth pulley

linpos = output.ELMO.pos_rad * pulleyradius;
linforce = output.ELMO.torque_Nm ./ pulleyradius;


%% calculate offsets
dt1 = output.time(2) - output.time(1);
zerorange = 4.5*1/dt1:5*1/dt1;
sp1offset = mean(output.sensors.drawWire_m(zerorange));
% sp2offset = mean(output.shoreADC.sp2(zerorange));
dt2 = output.time(2)-output.time(1);
zerorange = 4.5*1/dt2:5*1/dt2;
linposoffset = mean(linpos(zerorange));
dt3 = output.time(2)-output.time(1);
zerorange = 4.5*1/dt3:5*1/dt3;
LCtop_Noffset = mean(output.sensors.LCtop_N(zerorange));
LCbot_Noffset = mean(output.sensors.LCbot_N(zerorange));

%% modify signals with offsets
linPos = linpos-linposoffset;
SP1 = -(output.sensors.drawWire_m-sp1offset);
totalForce = (output.sensors.LCtop_N-LCtop_Noffset)-(output.sensors.LCbot_N-LCbot_Noffset);

%% plot stringpots and converted rotation
figure
plot(output.time,SP1)
hold on
plot(output.time,linPos)
legend('draw wire','converted motor rotation')
ylabel('displacement (m)')
grid on
ylim([-0.3 0.3])
title('Linear Position')

%% plot individual load cells
figure
plot(output.time,output.sensors.LCbot_N)
hold on
plot(output.time,output.sensors.LCtop_N)
legend('bottom','top')
grid on
xlabel('time(s)')
ylabel('F(N)')

%% plot Forces
figure
plot(output.time,linforce)
hold on
plot(output.time,totalForce)
legend('converted ELMO torque','combined top and bottom load cells')
% legend('Bottom Load Cell','-Top Load Cell','converted ELMO torque','converted torque transducer torque','combined top and bottom load cells')
xlabel('time (s)')
ylabel('F(N)')
grid on
title('Linear Force')

%% power calculations and plotting
% 
% figure
% subplot(311)
% plot(output.ELMO.time,output.ELMO.vel_radpers)
% hold on
% plot(output.ELMO.time,output.ELMO.vel_from_pos)
% 
% ylabel('velocity (rad/s)')
% legend('ELMO velocity','ELMO from position')
% ylim([-20 20])
% 
% subplot(312)
% plot(output.ELMO.time,output.ELMO.torque_Nm)
% ylabel('Torque (Nm)')

motorPower = output.ELMO.vel_radpers .* output.ELMO.torque_Nm;
LoadCellForce = output.sensors.LCbot_N-LCbot_Noffset-(output.sensors.LCtop_N-LCtop_Noffset);
% stringpotVelocity = gradient(output.ShoreADC.sp2-sp2offset,output.ShoreADC.time);
% beltPower = LoadCellForce .* stringpotVelocity;
figure
plot(output.time,motorPower)
hold on
% plot(output.time,beltPower)
ylabel('Power (W)')
xlabel('time (s)')
legend('Power at Motor','Power at Load Cells')
title('Power')

% figure
% subplot(211)
% plot(output.sensors.time,output.sensors.LCbot_N)
% hold on
% plot(output.sensors.time,output.sensors.LCtop_N)
% legend('LCbot_N','LCtop_N')
% ylabel('F (N)')
% grid on
% subplot(212)
% plot(output.sensors.time,output.sensors.LCbot_N)
% hold on
% plot(output.sensors.time,output.sensors.LCtop_N)
% legend('LCbot_N','LCtop_N')
% ylabel('F (N)')
% xlim([33 35])
% grid on
% xlabel('time (s)')
