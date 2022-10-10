clear; clc; close all
dateStr = datestr(now,'yyyymmdd');

numParameters = 2;  % stiffness and damping values

numValues = 40;     % number of pairs to generate
rng(3);             % set random generator seed
lhs = lhsdesign(numValues,numParameters);   % Latin hypercube sample 
%       kp, kd
PIlim = [0 0; ...       % lower limit of kp, kd
         0 2200];          % upper limit of kp, kd

% scale lhs to be in the desired range of values
rr = PIlim(2,:)-PIlim(1,:); 
ofst = PIlim(1,:);
lhs = lhs.*rr + ofst;

writematrix(lhs,['../ExcelGains/','dampingOnly_',dateStr,'.xlsx']);