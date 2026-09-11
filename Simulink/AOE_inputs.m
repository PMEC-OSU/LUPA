%% AOE Inputs
% Dimensions of compression cylinder used to calculate ICs and constants in AOE device 

% Set device and simulation time
% tf = 200;                   % Set simulation time
t_ramp = 30;                % Set ramp time
dt = 0.001;                 % Set timestep
N   = tf/dt;                % Calculate time steps
N_ramp = t_ramp/dt;         % Calculate ramp time steps
N_steady = N - N_ramp;      % Calculate steady state time steps

%% Design Variable Inputs

MOGA = 0;

% Design input
if MOGA == 0
    design = [101300	2.217413623	1	3.255	0.25 0];
    
    inputs.InletPressure    = design(1); 
    inputs.PressureRatio    = design(2);
    inputs.CylDiam          = design(3);
    inputs.CylLength        = design(4);
    inputs.OrificeRatio     = design(5);
    inputs.Offset           = design(6);

% Multi-objective genetic algorithm optimization
elseif MOGA == 1

    inputs.CylLength        = CylinderLength;
    inputs.CylDiam          = CylinderDiameter;
    inputs.PressureRatio    = PressureRatio;
    inputs.OrificeRatio     = OrificeRatio;
    inputs.Offset           = EndStopLocation*CylinderLength/2;
    inputs.InletPressure    = 206721.2953;

else
    error('Specify MOGA option: 1 = on, 0 = off')
end

% %% Wave Condition Inputs
% 
% heaveOnly = 0;
% 
% if heaveOnly == 1
% 
%     % Heave-only
%     conditions = [0.1	2];
%     H   = conditions(1);     % Height (m)
%     T   = conditions(2);     % Period (s)
% 
% else
% 
%     % 6DOF
%     conditions = [0.15	0.35];
%     A   = conditions(1); % Amplitude (m)
%     f   = conditions(2);  % Frequency (Hz)
% 
%     % Convert to height and period
%     H   = 2*A;      % Height (m)
%     T   = 1/f;  % Period (s)
% end