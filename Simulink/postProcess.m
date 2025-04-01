% Main LUPA postprocessing script

% clear; clc; close all

%% === parameters =========================================================
mdlName = bdroot;
modelWorkspace = get_param(mdlName,'ModelWorkspace');
tgName = getVariable(modelWorkspace,'tgName');

dateDir = datestr(now,'yyyymmdd');
timeDir = datestr(now,'HHMMss');
sharename = 'Z:';
% year = datestr(now,'yyyy');
year = '2025'; % initial tests in 2024, remove in 2025

if(~exist('app','var'))
    %% if running this script manually change these values!!!!!
    buildDir = fullfile('C:','simulink_build');
    % mdlName = 'LUPA';
    tgName = 'performance4';
    projectName = 'LUPA7';
    expname = 'Ramps';
    trialNumber = 1;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    app = [];
else
    projectName = [];
    expname = [];
    trialNumber = [];
end
matFileName = 'simdata.mat';

tg = pull_data(tgName,dateDir,timeDir,mdlName,matFileName);

output = structure_save_HWRL(matFileName,app,sharename,year,projectName,expname,trialNumber);
clear('app');
function output = structure_save_HWRL(matFileName,app,sharename,year,projectName,expname,trialNumber)
%% === convert to structure format ========================================
data1 = load(matFileName);
numdatasets = numElements(data1.SignalData);

for i = 1:numdatasets
    signalNames = fieldnames(data1.SignalData{i}.Values);
    for j = 1:length(signalNames)
        blockNameTot = data1.SignalData{i}.BlockPath.getBlock(1);
        level = wildcardPattern + "/";
        pat = asManyOfPattern(level);
        blockName = extractAfter(blockNameTot,pat);
        signalName = char(signalNames(j));
        output.(blockName).(signalName) = data1.SignalData{i}.Values.(signalName).Data;
        %         output.(blockName).time = data1.data{i}.Values.(signalName).Time;
    end
end
%% === convert timestamp to datetime format================================
output.time = data1.SignalData{end}.Values.timestamp.Time;
output.timestamp.UTCtime = datetime(output.timestamp.timestamp,'ConvertFrom','epochtime','TicksPerSecond',1e9,'Format','eee yyyy/MM/dd HH:mm:ss.SSSSSSSSS','TimeZone','UTC');
temp = output.timestamp.UTCtime;
temp.TimeZone = 'America/Los_Angeles';
output.timestamp.LocalTime = temp;
if(~isempty(app))
    output.reference.Amplitude = app.AmplitudeSpinner.Value;
    output.reference.Signal = app.SignalDropDown.Value;
    output.reference.CurrentLimit = app.CurrentLimitSpinner.Value;
    output.reference.SinePeriod = app.SinePeriodEditField.Value;
    output.control.Source = app.SourceDropDown.Value;
    output.feedback.Damping = app.DampingSpinner.Value;
    output.feedback.Stiffness = app.StiffnessSpinner.Value;
    output.feedback.time = 0:app.TsEditField.Value:length(output.feedback.vel_filt_radpers)*app.TsEditField.Value-app.TsEditField.Value;
    output.control.CurrentLimit = app.CurrentLimitSpinner.Value;
    output.trialData.Project = app.ProjectEditField.Value;
    output.trialData.Experiment = app.ExpEditField.Value;
    output.trialData.TrialNumber = app.TrialSpinner.Value;
    output.trialData.Ts = app.TsEditField.Value;
    output.trialData.sprocketTeeth = app.SprocketEditField.Value;
    output.trialData.Mode = app.ModeEditField.Value;

    projectName = app.ProjectEditField.Value;
    expname = app.ExpEditField.Value;
    trialNumber = app.TrialSpinner.Value;

else
    output.trialData.Project = projectName;
    output.trialData.Experiment = expname;
    output.trialData.TrialNumber = trialNumber;
end

trialname = ['\Trial',num2str(trialNumber,'%02d')];

dataexpname = ['C:\data\',projectName,'\',expname];
datadirname = fullfile(dataexpname,trialname);
if ~exist(datadirname,'dir')
    mkdir(datadirname);
end
formatOut = 'yyyymmdd_HHMMSS';
fname = ['d',datestr(output.timestamp.UTCtime(1),formatOut)];


save([datadirname,'\',fname,'.mat'],'output','-v7.3');

disp(['Data saved to ',datadirname,'\',fname,'.mat'])
if(strcmp(app.HWRLShareSwitch.Value,'Yes'))
    if(~isempty(app))
        % push data to share
        % build the directory structure. assumes HWRL project share conventions
        if ~exist(sharename,'dir') % give up if no HWRL share
            disp([projectName,': cannot find ',sharename])
        elseif ~exist(fullfile(sharename,'projects'),'dir') % give up if no projects folder
            disp([projectName,': cannot find ',fullfile(sharename,'projects')])
        elseif ~exist(fullfile(sharename,'projects',year),'dir') % give up if no projects/year folder
            disp([projectName,': cannot find ',fullfile(sharename,'projects',year)])
        elseif ~exist(fullfile(sharename,'projects',year,projectName),'dir') % give up if no project folder
            disp([projectName,': cannot find ',fullfile(sharename,'projects',year,projectName)])
        elseif ~exist(fullfile(sharename,'projects',year,projectName,'data','raw'),'dir') % give up if no raw folder
            disp([projectName,': cannot find ',fullfile(projectName,'data','raw')])
        else % we found the raw folder and can proceed
            expdirname = fullfile(sharename,'projects',year,projectName,'data','onboard',expname);
            if ~exist(expdirname,'dir') % create a experiment data directory if it doesn't exist yet
                mkdir(expdirname);
            end
            trialdirname = fullfile(expdirname,trialname);
            if ~exist(trialdirname,'dir') % create a trial data directory if it doesn't exist yet
                mkdir(trialdirname);
            end
            copyfile([datadirname,'\',fname,'.mat'],trialdirname)
            disp(['Data saved to ',trialdirname,'\',fname,'.mat'])
        end
    end
else
    disp('Data not saved to HWRL Share')
end
end
function tg = pull_data(tgName,dateDir,timeDir,mdlName,matFileName)

%% === test speedgoat connection ==========================================
tg = slrealtime(tgName);

try
    tg.connect
catch ME
    fprintf('\n*** Target %s not connected. Stopping program.  Check connection.\n',tgName)
    fprintf('\n*** Matlab error \n %s \n\n',ME.getReport)
    return
end

if tg.isConnected
    fprintf('\n*** Target %s is connected at IP address %s. \n\n',tg.TargetSettings.name,tg.TargetSettings.address)
end
ipAddress = tg.TargetSettings.address;

%% === copy data from target ==============================================
newFolder = fullfile('C:','data',dateDir,timeDir);
mkdir(newFolder);

system(['pscp -pw slrt -r slrt@', ipAddress, ':applications/',mdlName,' ',newFolder])
%% === Import Logged Data into MATLAB and view in Simulation Data Inspector
slrealtime.fileLogList('Directory',fullfile('C:/data',[dateDir,'/',timeDir]))
slrealtime.fileLogImport(mdlName,'Directory',fullfile('C:/data',[dateDir,'/',timeDir]))
% Simulink.sdi.view;

%% === Export to .mat file from Data Inspector ============================
runIDs = Simulink.sdi.getAllRunIDs;
runID = runIDs(end);

rtRun = Simulink.sdi.getRun(runID); % get data for last run

SignalData = rtRun.export;

save('simdata.mat','SignalData')
% Simulink.sdi.exportRun(runID,'to','file','filename',matFileName); % export to .mat

end
