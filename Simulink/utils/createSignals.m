clear; clc; close all


%% ------------MultiSine-------------------------------
fmin = 0.05; % min frequency for multisine
fmax = 1;    % max frequency for multisine
fs = 1000;
rLen = 600;  %% length of created signal (s) for multisine

sig = whiteNoiseGen(fs,fmin,fmax,rLen);

%% ------------Chirp-----------------------------------
f0 = 1/20;
f1 = 1/1;
fs = 1000;
initLength = 10;
numseconds = 300;
t = 0:1/fs:numseconds-1/fs;
t1 = numseconds;
chirp = chirp(t,f0,t1,f1);
r = 40/numseconds;
r_win = tukeywin(length(t),r)';
chirp = chirp .* r_win;
chirp = [zeros(1,fs*initLength) chirp];
t = 1/fs:1/fs:length(chirp)/fs;
sig.Chirp = timeseries(chirp,t);
plot(sig.Chirp)

%% ---------------Ramps---------------------------------
freq = 0.02; % 1/repeat time of single ramp
amp = 1;    % max amplitude of ramp and sine wave (will be scaled in simulink)
fs = 1000; % sampling frequency of ramp signal

ramp = zeros(6*fs*1/freq,1);

t=[1/fs:1/fs:(1/fs)*length(ramp)];

ramp(fs/(2*freq):fs/freq-1) = linspace(0,amp,(fs/freq-fs/(2*freq)));
ramp(3*fs/(2*freq):2*fs/freq-1) = linspace(0,-amp,(fs/freq-fs/(2*freq)));
ramp(5*fs/(2*freq):3*fs/freq-1) = linspace(0,amp,(fs/freq-fs/(2*freq)));
ramp(7*fs/(2*freq):4*fs/freq-1) = linspace(0,-amp,(fs/freq-fs/(2*freq)));

% ramp(fs/(2*freq):fs/freq-1) = linspace(0,amp,(fs/freq-fs/(2*freq)));
% ramp(4*fs/(2*freq):2.5*fs/freq-1) = linspace(0,-amp,(fs/freq-fs/(2*freq)));
% ramp(7*fs/(2*freq):4*fs/freq-1) = linspace(0,amp,(fs/freq-fs/(2*freq)));
% ramp(10*fs/(2*freq):5.5*fs/freq-1) = linspace(0,-amp,(fs/freq-fs/(2*freq)));


sig.Ramp = timeseries(ramp,t);

%% ---------------Sine---------------------------------
period = 3; % period for sine wave
sineDuration = 50;
initLength = 10;
t = 1/fs:1/fs:sineDuration;
sine = amp .* sin(2*pi./period*t);
sine = [zeros(1,fs*initLength) sine];
t = 1/fs:1/fs:length(sine)/fs;
sig.Sine = timeseries(sine,t);



%% ---------------Combine into input signals---------------------
commandSigs = Simulink.SimulationData.Dataset;
commandSigs = commandSigs.addElement(sig.Ramp,'Ramp');
commandSigs = commandSigs.addElement(sig.Sine,'Sine');
commandSigs = commandSigs.addElement(sig.WN1,'WN1');
commandSigs = commandSigs.addElement(sig.WN2,'WN2');
commandSigs = commandSigs.addElement(sig.WN3,'WN3');
commandSigs = commandSigs.addElement(sig.Chirp,'Chirp');
save('C:\LUPA\Simulink\utils\commandSignals','commandSigs')

figure
subplot(311)
plot(sig.Ramp)
xlabel('time (s)')
ylabel('ramp amplitude')

subplot(312)
plot(sig.Sine)
xlabel('time (s)')
ylabel('sine signal')

subplot(313)
plot(sig.WN1)
hold on
plot(sig.WN2)
plot(sig.WN3)
xlabel('time (s)')
ylabel('white noise signal')
legend('WN1','WN2','WN3')
