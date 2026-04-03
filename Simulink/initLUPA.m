%% Main LUPA initialization script
clear; clc; close all
addpath('utils')
%% === Assign Constants ===================================================
disp('*** Setting model parameters ***')



excelFile = 'ExcelGains/dampStiffPer4.xlsx';
gainTstep = 4*10; % time between change in excel gains (s) (Represents the wave period times 20 waves)

Mode = 'One Body Heave Only'; % 'One Body Heave Only' 'Two Body Heave Only' 'Six DOF'
Ts = 0.001; % sampling period 0.001, or 0.0005, or 0.00025 (doesn't get past state 2)
CL = 13;  % Current limit parameter
Kt = 7.86;  % Determined experimentally  % Kt = 8.51;  % From datasheet
sprocketTeeth = 50;  % small:32 medium:50 large:80
tgName = 'performance4';

%% change things above this line for each run

load('refSigs.mat')
ExcelGains = readtable(excelFile);  % read from excel spreadsheet gain values
ExcelGains = table2array(ExcelGains);

% Create variables for reference signals
T = 5;
Ts = 0.001;
Tsin = 2.25;
stepTime = 10;
t = 25:25:200;
rampTime = 20;

appName = 'LUPAapp';
buildDir = fullfile('C:','simulink_code');
mdlName = 'LUPA';

% select sprocket radius based on the physically installed number of teeth
sprocketPitchRadius = sprocket(sprocketTeeth);
% choose decimation values for app and logging
[appDecimation,appDecimationAxes,decimationLog] = decimationDef(Ts);

lowpass_dt = c2d(tf([1 0],[1 2*pi/100]),Ts,'impulse');
bandpass_dt = c2d(tf([1 0],[1 2*pi/100])*tf(2*pi*200,[1 2*pi*200]),Ts,'impulse');

mdlInfo = Simulink.MDLInfo(mdlName);
mdlVersion = mdlInfo.ModelVersion;
disp('*** Open Simulink Model ***')
open_system(mdlName);

set_param(mdlName,'LoadExternalInput','on');
load_system(mdlName);

eniPath = fullfile(pwd,'EtherCAT/LUPAxml.xml');
set_param([mdlName,'/Initialization/EtherCAT Init'],'config_file',eniPath);
set_param(mdlName, 'RTWVerbose','off');

slbuild(mdlName)

allfigs = findall(0,'Type','figure');
app2handle = findall(allfigs,'Name','LUPA');
app2handle.delete
disp('*** Start user app ***')
run(appName)





function sprocketPitchRadius = sprocket(sprocketTeeth)

if sprocketTeeth == 32
    sprocketPitchRadius = 0.0407416;
elseif sprocketTeeth == 50
    sprocketPitchRadius = 0.0636651;
elseif sprocketTeeth == 80
    sprocketPitchRadius = 0.101854;
end

end

function [appDecimation,appDecimationAxes,decimationLog] = decimationDef(Ts)

if Ts == 0.001
    appDecimation = 200;
    appDecimationAxes = 100;
    decimationLog = 1;
elseif Ts == 0.0005
    appDecimation = 200*2;
    appDecimationAxes = 100*2;
    decimationLog = 1*2;
elseif Ts == 0.00025
    appDecimation = 200*4;
    appDecimationAxes = 100*4;
    decimationLog = 1*4;
else
    disp('Error: choose a valid sampling period')
end

end