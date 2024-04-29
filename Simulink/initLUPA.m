clear; clc; close all
addpath('utils')
%% === Assign Constants ===================================================
disp('*** Setting model parameters ***')
period = 3; % period for sine wave
excelFile = 'ExcelGains/dampingOnly_20221128.xlsx';
gainTstep = 1.875*20; % time between change in excel gains (s) (Represents the wave period times 20 waves)

Mode = 'One Body Heave Only'; % 'One Body Heave Only' 'Two Body Heave Only' 'Six DOF'
Ts = 0.001; % sampling period 0.001, or 0.0005, or 0.00025 (doesn't get past state 2)
CL = 13;  % Current limit parameter (Set in EASII)
Kt = 7.86;  % Determined experimentally  % Kt = 8.51;  % From datasheet
sprocketTeeth = 50;  % small:32 medium:50 large:80
tgName = 'performance3';


%% change things above this line for each run

appName = 'LUPAapp.mlapp';
buildDir = fullfile('C:','simulink_build');
mdlName = 'LUPA';

% select sprocket radius based on the physically installed number of teeth
sprocketPitchRadius = sprocket(sprocketTeeth);
% choose decimation values for app and logging
[appDecimation,appDecimationAxes,decimationLog] = decimationDef(Ts);

bandpass_dt = c2d(tf([1 0],[1 2*pi/100])*tf(2*pi*200,[1 2*pi*200]),Ts,'impulse');

mdlInfo = Simulink.MDLInfo(mdlName);
mdlVersion = mdlInfo.ModelVersion;

%% === Open the model =========================================
disp('*** Open Simulink Model ***')
open_system(mdlName);

%% === load input signals =========================================
disp('*** Load Input command signals ***')
load('utils/commandSignals.mat');
commandSigs = modifySine(commandSigs,period);
waveform = commandSigs;
set_param(mdlName,'ExternalInput','waveform');

%% === load excel gains =======================================

ExcelGains = readtable(excelFile);  % read from excel spreadsheet gain values
ExcelGains = table2array(ExcelGains);

%% === Load and compile the model =========================================
disp('*** Load and Build Simulink Model ***')
set_param(mdlName,'LoadExternalInput','on');
set_param(mdlName,'StopTime','Inf');
load_system(mdlName)
set_param(mdlName, 'RTWVerbose','off');

%% === set xml file based on sampling frequency============================
selectXMLfile(Ts,mdlName);
% LUPA_eCat_init = strcat('C:\Software\LUPA-Checkout\TwinCAT\LUPACheckout\FilterStudy2\LUPACheckout1kHzF30kHz.xml');
% set_param([mdlName,'/Initialization/EtherCAT Init'],'config_file',LUPA_eCat_init);

%% === Build Model ========================================================
disp('*** Build Simulink RT (Speedgoat) ***')
% tg=slrealtime;
slbuild(mdlName);
% load(tg,mdlName);

%% === Open the app =======================================================
% remove any open app windows
allfigs = findall(0,'Type', 'figure');  % get handles to *all* figures
app2Handle = findall(allfigs, 'Name', 'LUPA');  % isolate the app's handle based on the App's name.
app2Handle.delete
disp('*** Start user app ***')
run(appName)

%% === Functions for readability of code ==================================

function selectXMLfile(Ts,mdlName)

% set the full path to the EtherCAT config files.
current_dir = pwd;

if Ts == 0.001
    LUPA_eCat_init = strcat(current_dir,'\EtherCAT\LUPA1kHz.xml');
elseif Ts == 0.0005
    LUPA_eCat_init = strcat(current_dir,'\EtherCAT\LUPA2kHz.xml');
elseif Ts == 0.00025
    LUPA_eCat_init = strcat(current_dir,'\EtherCAT\LUPA4kHz.xml');
else
    disp('Error: choose a valid sampling period')
end

set_param([mdlName,'/Initialization/EtherCAT Init'],'config_file',LUPA_eCat_init);

end

function commandSigs = modifySine(commandSigs,period)

sineDuration = 180;
initLength = 10;
fs = 1000;
amp = 1;  % Leave this at 1 and change in App
t = 1/fs:1/fs:sineDuration;
sine = amp .* sin(2*pi./period*t);
sine = [zeros(1,fs*initLength) sine];
t = 1/fs:1/fs:length(sine)/fs;
sig.Sine = timeseries(sine,t);
commandSigs = commandSigs.setElement(2,sig.Sine,'Sine');
end

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