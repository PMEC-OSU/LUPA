clear; clc; close all
addpath(genpath('utils/'))
%% === Assign Constants ===================================================
disp('*** Setting model parameters ***')

Mode = 'Six DOF'; % 'One Body Heave Only' 'Two Body Heave Only' 'Six DOF'
period = 3; % period for sine wave
Ts = 0.001; % sampling period
CL = 13;  % Current limit parameter (Set in EASII)
Kt = 7.86;  % Determined experimentally  % Kt = 8.51;  % From datasheet
sprocketTeeth = 50;  % small:32 medium:50 large:80
tgName = 'performance3';
excelFile = 'ExcelGains/dampingOnly_20221128.xlsx';

%% change things above this line for each run

appName = 'LUPAapp.mlapp';
buildDir = fullfile('C:','simulink_build');
mdlName = 'LUPA';

if sprocketTeeth == 32
    sprocketPitchRadius = 0.0407416;
elseif sprocketTeeth == 50
    sprocketPitchRadius = 0.0636651;
elseif sprocketTeeth == 80
    sprocketPitchRadius = 0.101854;
end

Decimation = 1;
Decimation100Hz = 0.01./Ts;

bandpass_dt = c2d(tf([1 0],[1 2*pi/100])*tf(2*pi*200,[1 2*pi*200]),Ts,'impulse');

mdlInfo = Simulink.MDLInfo(mdlName);
mdlVersion = mdlInfo.ModelVersion;
% addpath(genpath(pwd))
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
gainTstep = 1.875*20; % time between change in gains (s) (Represents the wave period times 20 waves)
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

LUPA_eCat_init = strcat(current_dir,'\EtherCAT\LUPA1kHz_DC.xml');

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