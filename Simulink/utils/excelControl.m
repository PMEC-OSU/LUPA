clear; clc; close all

numParameters = 2;

numValues = 40;
rng(3);
lhs = lhsdesign(numValues,numParameters);
%       kp, kd
PIlim = [0 0; ...
         0 3];

rr = PIlim(2,:)-PIlim(1,:);
ofst = PIlim(1,:);

lhs = lhs.*rr + ofst;

writematrix(lhs,'LUPA_dampingOnly.xlsx');