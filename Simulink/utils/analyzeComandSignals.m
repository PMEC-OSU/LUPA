clear; clc; close all
h=3.695;

% load commandSignals.mat
load refSigs.mat


ms1stats = wave_statistics(h,squeeze(ds{1}.MS1.Data),ds{1}.MS1.Time);
ms2stats = wave_statistics(h,squeeze(ds{1}.MS2.Data),ds{1}.MS2.Time);
ms3stats = wave_statistics(h,squeeze(ds{1}.MS3.Data),ds{1}.MS3.Time);

figure
stem(ms1stats.psd.f,ms1stats.psd.S)
hold on
stem(ms2stats.psd.f,ms2stats.psd.S)
stem(ms3stats.psd.f,ms3stats.psd.S)

xlim([0 2.5])