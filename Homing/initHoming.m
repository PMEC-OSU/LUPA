%% Main Homing LUPA initialization script
clear; clc; close all

%% === Assign Constants ===================================================
disp('*** Setting model parameters ***')

Ts = 0.001;
mdlName = 'Homing';
mdlInfo = Simulink.MDLInfo(mdlName);
mdlVersion = mdlInfo.ModelVersion;
set_param(mdlName, 'RTWVerbose','off');
buildDir = fullfile('C:','simulink_code');
tgName = 'performance4';
appName = 'HomingApp.mlapp';

slbuild(mdlName)

allfigs = findall(0,'Type','figure');
app2handle = findall(allfigs,'Name','LUPA Homing');
app2handle.delete
disp('*** Start user app ***')
run(appName)