clear; clc; close all
h=3.695;

load commandSignals.mat

ms1stats = wave_statistics(h,squeeze(commandSigs{3}.Data),commandSigs{3}.Time);
ms2stats = wave_statistics(h,squeeze(commandSigs{4}.Data),commandSigs{4}.Time);
ms3stats = wave_statistics(h,squeeze(commandSigs{5}.Data),commandSigs{5}.Time);

figure
stem(ms1stats.psd.f,ms1stats.psd.S)
hold on
stem(ms2stats.psd.f,ms2stats.psd.S)
stem(ms3stats.psd.f,ms3stats.psd.S)

xlim([0 2.5])