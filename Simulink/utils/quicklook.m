clc; close all


%% plot torque data
figure('Name','Velocity, Torque, and Mechanical Power')
subplot(3,1,1)
plot(output.time,output.ELMO.vel_radpers)
hold on
plot(output.time,output.ELMO.vel_from_pos_radpers)
ylabel('velocity rad/s')
grid on
legend('Drive Reported','calculated from position')
subplot(3,1,2)
plot(output.time,output.ELMO.torque_Nm)
hold on
plot(output.time,output.control.target_A*7.86)
ylabel('Torque (Nm)')
legend('Drive reported','command signal')
grid on
subplot(3,1,3)
plot(output.time,output.ELMO.pow_W)
ylabel('Power (W)')
xlabel('time (s)')
grid on
sgtitle('Mechanical Power')

%% plot shore adc signals
figure('Name','Shore ADC')
plot(output.time,output.shoreADC.wmstart)
hold on
plot(output.time,output.shoreADC.led)

legend('wmstart','led')
grid on
xlabel('time(s)')
ylabel('V')

%% plot intitialization signals
figure('Name','Initialization')
subplot(2,1,1)
plot(output.time,output.initialization.eCATstate)
hold on
plot(output.time,output.initialization.opState)
legend('opstate value','opstate=8')
grid on
title('EtherCAT Initialization')
subplot(2,1,2)
plot(output.time,output.initialization.tet)
grid on
xlabel('time(s)')
ylabel('time (s)')
title('TET')

%% plot motor temperature
figure('Name','Motor Temperature')
plot(output.time,output.sensors.motorTemp_degC)
grid on
xlabel('time(s)')
ylabel('\circC')
%% rotary to linear conversion
% pulleyradius = 0.0407416;   % 32 tooth pulley
pulleyradius = 0.0636651;   % 50 tooth pulley
% pulleyradius = 0.101854;   % 80 tooth pulley

linpos = output.ELMO.pos_rad * pulleyradius;
linforce = output.ELMO.torque_Nm ./ pulleyradius;

%% plot individual load cells and combined force
figure('Name','Load Cells and combined force')
plot(output.time,output.sensors.LCbot_N)
hold on
plot(output.time,output.sensors.LCtop_N)
plot(output.time,output.linearMotion.netForce_N)

legend('bottom','top','combined')
grid on
xlabel('time(s)')
ylabel('F(N)')

%% plot stringpots and converted rotation
figure('Name','Displacement')
plot(output.time,output.sensors.drawWire_m)
hold on
plot(output.time,output.customControl.z)
legend('draw wire','converted motor rotation')
xlabel('time (s)')
ylabel('displacement (m)')
grid on
ylim([-0.3 0.3])
title('Linear Position')



%% AOE specific outputs
figure('Name','AOE outputs')
subplot(3,1,1)
plot(output.time,output.customControl.Ex)
grid on
title('Exergy')
ylabel('W')
subplot(3,1,2)
plot(output.time,output.customControl.F_PTO)
hold on
plot(output.time,output.customControl.Fh)
plot(output.time,output.customControl.Fl)
legend('F_PTO','Fh','Fl','Interpreter','none')
grid on
ylabel('N')
title('Forces')
subplot(3,1,3)
plot(output.time,output.customControl.PT)
grid on
ylabel('Pa')
title('Pressure')
