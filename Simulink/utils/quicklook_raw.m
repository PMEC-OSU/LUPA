clear; clc; close all
%% Choose experiment name and trialnumber for quicklook
expname = 'Ramps3';
trialnum = 18;

%% load data
trialname = ['Trial',num2str(trialnum,'%02d')];
trialdir = fullfile('Z:\projects\2022\DryLUPA\data\raw',expname,trialname);
dircontents = dir(trialdir);
filename = dircontents(3).name;
load([trialdir,'\',filename])
%% timestamp analysis
figure
plot(diff(output.time))
xlabel('samples')
ylabel('period (s)')
title('\Delta t variations')

%% plot position data
figure
subplot(211)
plot(output.time,output.ELMO.pos_rad)
grid on
xlabel('time (s)')
ylabel('pos (rad)')
title('Motor Position')

subplot(212)
plot(output.time,output.Sensors.drawWire)
grid on
xlabel('time (s)')
ylabel('pos (m)')
title('relative body position')
ylim([.25 .75])


%% plot torque data
figure
subplot(211)
plot(output.time,output.ELMO.torque_Nm)
hold on
% plot(output.Control.time,output.Control.target_Nm)
xlabel('time (s)')
ylabel('Torque (Nm)')
legend('Drive reported','command signal')
grid on
title('Motor Torque')

%% load cell data
subplot(212)
plot(output.time,output.Sensors.LCbot)
hold on
plot(output.time,output.Sensors.LCtop)
legend('LCbot','LCtop')
ylabel('F (N)')
grid on

% %% rotary to linear conversion
% % pulleyradius = 0.0407416;   % 32 tooth pulley
% % pulleyradius = 0.0636651;   % 50 tooth pulley
% pulleyradius = 0.101854;   % 80 tooth pulley
% 
% linpos = output.ELMO.pos_rad * pulleyradius;
% linforce = output.ELMO.torque_Nm ./ pulleyradius;
% 
% 
% %% calculate offsets
% dt1 = output.ShoreADC.time(2) - output.ShoreADC.time(1);
% zerorange = 4.5*1/dt1:5*1/dt1;
% sp1offset = mean(output.Sensors.drawWire(zerorange));
% sp2offset = mean(output.ShoreADC.sp2(zerorange));
% dt2 = output.ELMO.time(2)-output.ELMO.time(1);
% zerorange = 4.5*1/dt2:5*1/dt2;
% linposoffset = mean(linpos(zerorange));
% dt3 = output.Sensors.time(2)-output.Sensors.time(1);
% zerorange = 4.5*1/dt3:5*1/dt3;
% LCtopoffset = mean(output.Sensors.LCtop(zerorange));
% LCbotoffset = mean(output.Sensors.LCbot(zerorange));
% 
% %% modify signals with offsets
% linPos = linpos-linposoffset;
% SP1 = -(output.Sensors.drawWire-sp1offset);
% totalForce = (output.Sensors.LCtop-LCtopoffset)-(output.Sensors.LCbot-LCbotoffset);
% 
% %% plot stringpots and converted rotation
% figure
% plot(output.Sensors.time,SP1)
% hold on
% plot(output.ELMO.time,linPos)
% legend('draw wire','converted motor rotation')
% ylabel('displacement (m)')
% grid on
% ylim([-0.3 0.3])
% title('Linear Position')
% 
% %% plot individual load cells
% figure
% plot(output.Sensors.time,output.Sensors.LCbot)
% hold on
% plot(output.Sensors.time,output.Sensors.LCtop)
% legend('bottom','top')
% grid on
% xlabel('time(s)')
% ylabel('F(N)')
% 
% %% plot Forces
% figure
% plot(output.ELMO.time,linforce)
% hold on
% plot(output.Sensors.time,totalForce)
% legend('converted ELMO torque','combined top and bottom load cells')
% % legend('Bottom Load Cell','-Top Load Cell','converted ELMO torque','converted torque transducer torque','combined top and bottom load cells')
% xlabel('time (s)')
% ylabel('F(N)')
% grid on
% title('Linear Force')
% 
% %% power calculations and plotting
% % 
% % figure
% % subplot(311)
% % plot(output.ELMO.time,output.ELMO.vel_radpers)
% % hold on
% % plot(output.ELMO.time,output.ELMO.vel_from_pos)
% % 
% % ylabel('velocity (rad/s)')
% % legend('ELMO velocity','ELMO from position')
% % ylim([-20 20])
% % 
% % subplot(312)
% % plot(output.ELMO.time,output.ELMO.torque_Nm)
% % ylabel('Torque (Nm)')
% 
% motorPower = output.ELMO.vel_radpers .* output.ELMO.torque_Nm;
% LoadCellForce = output.Sensors.LCbot-LCbotoffset-(output.Sensors.LCtop-LCtopoffset);
% stringpotVelocity = gradient(output.ShoreADC.sp2-sp2offset,output.ShoreADC.time);
% beltPower = LoadCellForce .* stringpotVelocity;
% figure
% plot(output.ELMO.time,motorPower)
% hold on
% plot(output.Sensors.time,beltPower)
% ylabel('Power (W)')
% xlabel('time (s)')
% legend('Power at Motor','Power at Load Cells')
% title('Power')
% 

