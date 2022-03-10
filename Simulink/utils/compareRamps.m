clear; clc; close all

Kt = 7.86;

%% Choose experiment name and trialnumber for quicklook
expname = {'Ramps2','Ramps2'};
trialnum = [1 4];
% pulleyradius = 0.0407416;   % 32 tooth pulley
% pulleyradius = 0.0636651;   % 50 tooth pulley
pulleyradius = 0.101854;   % 80 tooth pulley



for i = 1:length(expname)
    %% load data
    trialname = ['Trial',num2str(trialnum(i),'%02d')];
    trialdir = fullfile('Z:\projects\2022\DryLUPA\data\raw',expname{i},trialname);
    dircontents = dir(trialdir);
    filename = dircontents(3).name;
    load([trialdir,'\',filename])
    dt = output.ELMO.time(2) - output.ELMO.time(1);

    %% plot motor position data
    figure(1)
    subplot(2,1,1)
    hold on
    plot(output.ELMO.time,output.ELMO.pos_rad-output.ELMO.pos_rad(10./dt),'DisplayName',[trialname,': Measured'])
    xlabel('time (s)')
    ylabel('Motor Position (rad)')
    hold off
    legend show
    grid on
    title('Motor Position Comparison')

    %% plot torque data
    subplot(2,1,2)
    hold on
    plot(output.ELMO.time,output.ELMO.torque_Nm,'DisplayName',[trialname,': Measured'])
    plot(output.Control.time,output.Control.target_A*Kt,'DisplayName',[trialname,': Commanded'])
    xlabel('time (s)')
    ylabel('Motor Torque (Nm)')
    hold off
    legend show
    grid on
    title('Motor Torque Comparison')

    %% plot relative body position
    figure(2)
    subplot(2,1,1)
    hold on
    plot(output.Sensors.time,output.Sensors.drawWire-output.Sensors.drawWire(10./dt),'DisplayName',[trialname,': Measured'])
    xlabel('time (s)')
    ylabel('Relative Position (m)')
    hold off
    legend show
    grid on
    title('Relative Body Position')
    ylim([-.2 .2])
    
    %% plot combined load cell force
    zerorange = 4.5*1/dt:5*1/dt;
    LCtopoffset = mean(output.Sensors.LCtop(zerorange));
    LCbotoffset = mean(output.Sensors.LCbot(zerorange));
    subplot(2,1,2)
    hold on
    plot(output.Sensors.time,(output.Sensors.LCtop-LCtopoffset) - (output.Sensors.LCbot-LCbotoffset),'DisplayName',[trialname,': Measured'])
    xlabel('time (s)')
    ylabel('Relative Force (N)')
    hold off
    legend show
    grid on
    title('Relative Force between bodies')
%     ylim([-.2 .2])
end


% %% rotary to linear conversion
% % pulleyradius = 0.0407416;   % 32 tooth pulley
% % pulleyradius = 0.0636651;   % 50 tooth pulley
% pulleyradius = 0.101854;   % 80 tooth pulley
%
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
% totalForce = output.Sensors.LCbot-LCbotoffset-(output.Sensors.LCtop-LCtopoffset);
%
% %% plot stringpots and converted rotation
% figure
% plot(output.Sensors.time,SP1)
% hold on
% plot(output.ELMO.time,linPos)
% legend('- draw wire','converted motor rotation')
% ylabel('displacement (m)')
% grid on
% ylim([-0.3 0.3])
%
% %% plot load cells
% figure
% % plot(output.Sensors.time,output.Sensors.LCbot-LCbotoffset)
% % hold on
% % plot(output.Sensors.time,-(output.Sensors.LCtop-LCtopoffset))
% plot(output.ELMO.time,linforce)
% hold on
% plot(output.Sensors.time,totalForce)
% legend('converted ELMO torque','combined top and bottom load cells')
% % legend('Bottom Load Cell','-Top Load Cell','converted ELMO torque','converted torque transducer torque','combined top and bottom load cells')
% xlabel('time (s)')
% ylabel('F(N)')
% grid on
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
%
% % figure
% % subplot(211)
% % plot(output.Sensors.time,output.Sensors.LCbot)
% % hold on
% % plot(output.Sensors.time,output.Sensors.LCtop)
% % legend('LCbot','LCtop')
% % ylabel('F (N)')
% % grid on
% % subplot(212)
% % plot(output.Sensors.time,output.Sensors.LCbot)
% % hold on
% % plot(output.Sensors.time,output.Sensors.LCtop)
% % legend('LCbot','LCtop')
% % ylabel('F (N)')
% % xlim([33 35])
% % grid on
% % xlabel('time (s)')
