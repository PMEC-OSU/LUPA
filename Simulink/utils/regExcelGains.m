clear; clc; close all

x_wg = 28.688;
h = 2.74;
T = [1.23 1.38 1.68 2.5 3 4 5 6]';

stillwatertime = 30;
ramptime = 20;
dampingvalues = 100:100:2000;
numPeriods = 10;

for i = 1:length(T)

[tau1(i,1),tau2(i,1)] = mCDRLUPA8_bounce(x_wg,h,T(i));

timetofirstdamp(i,1) = stillwatertime + ramptime + tau1(i,1);
numzerostofirstdamp(i,1) = ceil(timetofirstdamp(i,1)./(numPeriods*T(i)));
dampmatrix = [zeros(numzerostofirstdamp(i,1),2);[zeros(length(dampingvalues),1) dampingvalues']];

writematrix(dampmatrix, ['Z:\projects\2026\mCDRLUPA8\docs\setup\ExcelGains\dampPer',num2str(T(i)),'.xlsx'])

end

bounce = 3*tau1+tau2;


tautable = table(T,tau1,tau2,bounce,timetofirstdamp,numzerostofirstdamp);

tautable{:,:} = round(tautable{:,:}, 3);
disp(tautable)

fig = uifigure('Visible', 'on');

uit=uitable(fig, 'Data', tautable, 'Position', [20 20 100 100]);

extent = get(uit, 'Extent');

newWidth = 2*extent(3);
newHeight = extent(4);
set(uit, 'Position', [20 20 newWidth newHeight]);

exportapp(fig,'tautable.pdf')

fig.Position(3:4) = [newWidth+40 newHeight+40];
