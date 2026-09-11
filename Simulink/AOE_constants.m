function [AOE] = AOE_constants(inputs)

%% Constants for the AOE simulink model
% please run this before running the AOE simulink model. This script
% contains all the necessary ICs and constants for the simulink model to
% compile

% Constant                    Definition

% Rs                          Specific gas constant(J/(kg*K)
% gma                         Heat capacity ratio cp/cv
% AtmPressure                 Atmospheric pressure (Pa)
% WaterTemperature            Atmospheric temperature (K)
% Gain                        Gain used for changing some parameters down the line
% Damping                     Damping coefficient (kg/s)
% Diameter                    Diameter of the cross section (m)
% CrossSectionalArea          CrossSectionalArea (m^2)
% SurfaceArea                 The surface area of the volume surrounding the air mass. This used for heat transfer rate calculation purposes (m^2)                 
% Stiffness                   Stiffness coefficient (N/m)
% Mass                        Mass of the check valve ball (kg)
% ExtensionLimit_Mechanical   Mechanical extension limit (m)
% ExtensionLimit_MassFlow     Maximum mass-flow distance threshold (m)
% HeatConvection              Heat convection coefficient with the sea water (W/K*m^2)
% EndStopDamping              Damping coefficient for the cylinder. Gets activated when it's in the end-stop region (kg/s)
% EndStopStiffness            Stiffness coefficient for the cylinder. Gets activated when it's in the end-stop region (N/m)
% LowEndLimit                 Buffer used to activate EndStopDamping & EndStopStiffness near the low end of the cylinder (m)
% HighEndLimit                Buffer used to activate EndStopDamping & EndStopStiffness near the high end of the cylinder (m)
% CoulombFrictionGain         The gain used to determine the value of the Coulomb friction force
% CoulombFrictionLimit        The saturation limit for the Coulomb friction (N)    
% InitialPistonPosition       Initial position of the piston in the cylinder (m)
% InitialPressure             Initial pressure of the vessel (Pa)
% InitialTemperature          Initial temperature of the vessel (K)
% InitialVolume               Initial volume of the vessel (m^3)
% InitialAirMass              Initial air mass of the vessel (kg)
% RegulatedPressure           Pressure threshold where the valve lets air through (Pa)
% ValveGate                   Indicates whether the gate is open (1) or closed (0)

% Simulink Block name         Definition

% InletCylinderOrifice        Air inlet orifice that connects the atmosphere to the cylinder
% InletCylinderCheckValve     Check valve that lets air flow in the cylinder
% cylinder                    Main cylinder that pumps air to the thank
% Chamber1                    Chamber #1 of the main cylinder
% Chamber2                    Chamber #2 of the main cylinder
% Chamber1Chamber2Orifice     Orifice connects chamber #1 to chamber #2 
% Chamber1Chamber2CheckValve  Check valve that lets air flow from chamber #1 to chamber #2
% Chamber2Chamber1Orifice     Orifice connects chamber #2 to chamber #1 
% Chamber2Chamber1CheckValve  Check valve that lets air flow from chamber #2 to chamber #1
% OutletCylinderOrifice       Orifice connects the cylinder to the tank
% OutletCylinderCheckValve    Check valve that lets air flow from the cylinder to the thank
% Tank                        Storage vessel for the compressed air
% OutletTankOrifice           Orifice connects the tank to the next connected unit
% OutletTankCheckValve        Check valve that lets air flow from the tank to the next connected unit

%% General Constants
AOE.lambda              = 10;           % Froude scaling factor for LUPA        %Luke, Jun. 9/26  
AOE.Rs                  = 288;          % For dry air 
AOE.gma                 = 1.4;          % air cp/cv
AOE.AtmPressure         = 101.3e3;      % 1 atm
AOE.AtmTemperature      = 293;          % 20 C Temperature of the air
%AOE.WaterTemperature    = 280;          % 7 C Temperature of the sea water      %Eric, Nov. 7/16
AOE.WaterTemperature    = 279; 
AOE.Cp                  = 1005;         %J / kgK for air @ 300 K          %Eric, Nov. 18/16
AOE.OrificeRatio        = inputs.OrificeRatio; %0.2447;                        %Eric, Nov. 25/16

%% Initial Temperature Coefficients (Estimates taken from '20 min Simulation Results.xlsx')
C2 = -2.24858675297471E-10;
C1 = 0.000547411355122799;
C = 258.803991051052;

%All coefficients used to approximate initial pressure are also given in '20 min Simulation Results.xlsx'

%% Cylinder

AOE.Cylinder.Length               = inputs.CylLength;
AOE.Cylinder.Diameter             = inputs.CylDiam;
AOE.Cylinder.CrossSectionalArea   = 0.25*pi*(AOE.Cylinder.Diameter)^2;
AOE.Cylinder.HeatConvection       = 0.2;  %This was referenced by Helen, Nov. 8/16
AOE.Cylinder.EndStopDamping       = 5*10^6;
AOE.Cylinder.EndStopStiffness     = 5*10^7;
AOE.Cylinder.LowEndLimit          = 0.05*AOE.Cylinder.Length;
AOE.Cylinder.HighEndLimit         = 0.05*AOE.Cylinder.Length;
AOE.Cylinder.CoulombFrictionLimit = 0.4*AOE.Cylinder.Diameter*1E3;      %This was referenced by Helen, Nov. 8/16
AOE.Cylinder.CoulombFrictionGain  = 100000;
AOE.Cylinder.InitialOffset        = inputs.Offset;   % Offset to account for -0.42m * 10 = -4.2m initial displacement to pretension mooring

%% InletCylinderOrifice

AOE.InletCylinderOrifice.Diameter                         = AOE.Cylinder.Diameter*AOE.OrificeRatio; %Eric, Nov. 25/16 // Old value was: %0.35;
AOE.InletCylinderOrifice.CrossSectionalArea               = 0.25*pi*(AOE.InletCylinderOrifice.Diameter)^2;


%% Chamber1

AOE.Chamber1.InitialPistonPosition    = AOE.Cylinder.Length/2;          %Eric, Nov. 25/16
AOE.Chamber1.PressureIn               = inputs.InletPressure;
AOE.Chamber1.InitialPressure          = inputs.InletPressure*(inputs.PressureRatio + 3)/4; %*0.175;
AOE.Chamber1.InitialTemperature       = C2*(AOE.Chamber1.InitialPressure^2) + C1*AOE.Chamber1.InitialPressure + C;
AOE.Chamber1.InitialVolume            = AOE.Cylinder.CrossSectionalArea * AOE.Chamber1.InitialPistonPosition;
AOE.Chamber1.InitialAirMass           = AOE.Chamber1.InitialPressure * AOE.Chamber1.InitialVolume/(AOE.Rs*AOE.Chamber1.InitialTemperature);

%% Chamber1Chamber2Orifice

AOE.Chamber1Chamber2Orifice.Diameter                          = AOE.InletCylinderOrifice.Diameter; %Eric, Nov. 14/16  // Old value was: % 0.5*AOE.InletCylinderOrifice.Diameter;
AOE.Chamber1Chamber2Orifice.CrossSectionalArea                = 0.25*pi*(AOE.Chamber1Chamber2Orifice.Diameter)^2;


%% Chamber2

AOE.Chamber2.InitialPistonPosition    = AOE.Cylinder.Length - AOE.Chamber1.InitialPistonPosition;
AOE.Chamber2.InitialPressure          = inputs.InletPressure*(inputs.PressureRatio + 1)/2;
AOE.Chamber2.InitialTemperature       = C2*(AOE.Chamber2.InitialPressure^2) + C1*AOE.Chamber2.InitialPressure + C;
AOE.Chamber2.InitialVolume            = AOE.Cylinder.CrossSectionalArea * AOE.Chamber2.InitialPistonPosition;
AOE.Chamber2.InitialAirMass           = AOE.Chamber2.InitialPressure * AOE.Chamber2.InitialVolume/(AOE.Rs*AOE.Chamber2.InitialTemperature);

%% OutletCylinderOrifice

AOE.OutletCylinderOrifice.Diameter                        = AOE.InletCylinderOrifice.Diameter;
AOE.OutletCylinderOrifice.CrossSectionalArea              = 0.25*pi*(AOE.OutletCylinderOrifice.Diameter)^2;

%% Tank

AOE.Tank.InitialPressure      = inputs.InletPressure*(3*inputs.PressureRatio + 1)/4;
AOE.Tank.InitialTemperature   = C2*(AOE.Tank.InitialPressure^2) + C1*AOE.Tank.InitialPressure + C;
AOE.Tank.NumAccumulators      = 6; %Eric, Nov. 21/16 (from AOE report)
AOE.Tank.Radius               = 0.4572;  %Eric, Nov. 21/16 (from AOE report)
AOE.Tank.LengthNoCaps         = 1.63;     %Eric, Nov. 21/16 (from AOE report)
AOE.Tank.SurfaceArea          = AOE.Tank.NumAccumulators*( AOE.Tank.LengthNoCaps*pi*2*AOE.Tank.Radius + 4*pi*AOE.Tank.Radius );  %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Tank.Volume               = AOE.Tank.NumAccumulators*( pi*(AOE.Tank.Radius^2)*AOE.Tank.LengthNoCaps + (4/3)*pi*(AOE.Tank.Radius^3) ); %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Tank.InitialAirMass       = AOE.Tank.InitialPressure * AOE.Tank.Volume/(AOE.Rs*AOE.Tank.InitialTemperature);
AOE.Tank.HeatConvection       = AOE.Cylinder.HeatConvection;

%% OutletTankOrifice

AOE.OutletTankOrifice.Diameter                        = AOE.InletCylinderOrifice.Diameter ;
AOE.OutletTankOrifice.CrossSectionalArea              = 0.25*pi*(AOE.OutletTankOrifice.Diameter)^2;
AOE.OutletTankOrifice.CrackPressure                   = inputs.InletPressure*inputs.PressureRatio;
%*************************************************************************%

