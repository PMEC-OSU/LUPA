clear; clc; close all
%% Choose experiment name and trialnumber for quicklook
expname = 'Sine';
trialnum = 9;

%% load data
trialname = ['Trial',num2str(trialnum,'%02d')];
trialdir = fullfile('Z:\projects\2022\DryLUPA\data\raw',expname,trialname);
dircontents = dir(trialdir);
filename = dircontents(3).name;
load([trialdir,'\',filename])

%% plot torque data
figure
plot(output.TorqueTransducer.time,output.TorqueTransducer.torqueTransducer)
hold on
plot(output.ELMO.time,output.ELMO.torque_Nm)
plot(output.Control.time,output.Control.target_A*7.86)
xlabel('time (s)')
ylabel('Torque (Nm)')
legend('torque transducer','Drive reported','command signal')
grid on

%% rotary to linear conversion
pulleyradius = 0.1273302/2;
linpos = output.ELMO.pos_rad * pulleyradius;
linforce = output.ELMO.torque_Nm ./ pulleyradius;
linTTforce = output.TorqueTransducer.torqueTransducer ./ pulleyradius;


%% calculate offsets
dt1 = output.ShoreADC.time(2) - output.ShoreADC.time(1);
zerorange = 4.5*1/dt1:5*1/dt1;
sp1offset = mean(output.ShoreADC.sp1(zerorange));
sp2offset = mean(output.ShoreADC.sp2(zerorange));
dt2 = output.ELMO.time(2)-output.ELMO.time(1);
zerorange = 4.5*1/dt2:5*1/dt2;
linposoffset = mean(linpos(zerorange));
dt3 = output.LUPAinput.time(2)-output.LUPAinput.time(1);
zerorange = 4.5*1/dt3:5*1/dt3;
LCtopoffset = mean(output.LUPAinput.LCtop(zerorange));
LCbotoffset = mean(output.LUPAinput.LCbot(zerorange));
dt4 = output.TorqueTransducer.time(2)-output.TorqueTransducer.time(1);
zerorange = 4.5*1/dt4:5*1/dt4;
linTTforceoffset = mean(linTTforce(zerorange));

%% modify signals with offsets
linPos = linpos-linposoffset;
SP1 = -(output.ShoreADC.sp1-sp1offset);
SP2 = output.ShoreADC.sp2-sp2offset;
linTTForce = linTTforce-linTTforceoffset;
totalForce = output.LUPAinput.LCbot-LCbotoffset-(output.LUPAinput.LCtop-LCtopoffset);

%% plot stringpots and converted rotation
figure
plot(output.ShoreADC.time,SP1)
hold on
plot(output.ShoreADC.time,SP2)
plot(output.ELMO.time,linPos)
legend('- Bottom Stringpot','Top Stringpot','converted motor rotation')
ylabel('displacement (m)')
grid on

%% plot load cells
figure
% plot(output.LUPAinput.time,output.LUPAinput.LCbot-LCbotoffset)
% hold on
% plot(output.LUPAinput.time,-(output.LUPAinput.LCtop-LCtopoffset))
plot(output.ELMO.time,linforce)
hold on
plot(output.TorqueTransducer.time,linTTForce)
plot(output.LUPAinput.time,totalForce)
legend('converted ELMO torque','converted torque transducer torque','combined top and bottom load cells')
% legend('Bottom Load Cell','-Top Load Cell','converted ELMO torque','converted torque transducer torque','combined top and bottom load cells')
xlabel('time (s)')
ylabel('F(N)')
grid on

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
LoadCellForce = output.LUPAinput.LCbot-LCbotoffset-(output.LUPAinput.LCtop-LCtopoffset);
stringpotVelocity = gradient(output.ShoreADC.sp2-sp2offset,output.ShoreADC.time);
beltPower = LoadCellForce .* stringpotVelocity;
figure
plot(output.ELMO.time,motorPower)
hold on
plot(output.LUPAinput.time,beltPower)
ylabel('Power (W)')
xlabel('time (s)')
legend('Power at Motor','Power at Load Cells')

figure
subplot(211)
plot(output.LUPAinput.time,output.LUPAinput.LCbot)
hold on
plot(output.LUPAinput.time,output.LUPAinput.LCtop)
legend('LCbot','LCtop')
ylabel('F (N)')
grid on
subplot(212)
plot(output.LUPAinput.time,output.LUPAinput.LCbot)
hold on
plot(output.LUPAinput.time,output.LUPAinput.LCtop)
legend('LCbot','LCtop')
ylabel('F (N)')
xlim([33 35])
grid on
xlabel('time (s)')
