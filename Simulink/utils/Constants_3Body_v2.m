function [AOE] = Constants_3Body_v2(inputs)

%% Contants for the AOE simulink model
% please run this beforfe running the AOE simulink model. This script
% contains all the necessary ICs and constants for the simulink model to
% compile

% Constant                    Definition

% Rs                          Specific gass constant(J/(kg*K)
% gma                         Heat capacity ratio cp/cv
% AtmPressure                 Atmospheric pressure (Pa)
% WaterTemperature            Atmospheric temperature (K)
% Gain                        Gain used for changing some parameters down the line
% Damping                     Damping coefficient (kg/s)
% Diameter                    Diameter of the cross section (m)
% CrossSectionalArea          CrossSectionalArea (m^2)
% SurfaceArea                 The surface area of the volume surrounding the air mass. This used for heat transfer rate calculation purposes (m^2)                 
% Stiffness                   Stifness coefficient (N/m)
% Mass                        Mass of the check valve ball (kg)
% ExtensionLimit_Mechanical   Mechanical extension limit (m)
% ExtensionLimit_MassFlow     Maximum massflow distance threshold (m)
% HeatConvection              Heat convection coefficient with the sea water (W/K*m^2)
% EndStopDamping              Damping coefficient for the cylinder. Gets activated when it's in the Endstop region (kg/s)
% EndStopStiffness            Stiffness coefficient for the cylinder. Gets activated when it's in the Endstop region (N/m)
% LowEndLimit                 Buffer used to activate EndStopDamping & EndStopStiffness near the low end of the cylinder (m)
% HighEndLimit                Buffer used to activate EndStopDamping & EndStopStiffness near the high end of the cylinder (m)
% CoulombFrictionGain         The gain used to determine the value of the Coulomb friction force
% CoulombFrictionLimit        The saturation limit for the Coulomb friction (N)    
% InitialPistonPosition       Initial position of the piston in the cylider (m)
% InitialPressure             Initial pressure of the vessel (Pa)
% InitialTemperature          Initial temperatur of the vessel (K)
% InitialVolume               Initial volume of the vessel (m^3)
% InitialAirMass              Initial air mass of the vessel (kg)
% RegulatedPressure           Pressure threshold where the valve lets air through (Pa)
% ValveGate                   Indicates whether the gate is open (1) or closed (0)

% Simulink Block name         Definition

% InletCylinderOrifice        Air inlet orifice that connects the atmosphere to the cylinder
% InletCylinderCheckValve     Check valve that lets air flow in the cylider
% cylinder                    Main cylinder that pumps air to the thank
% Chamber1                    Chamber #1 of the main cylidner
% Chamber2                    Chamber #2 of the main cylidner
% Chamber1Chamber2Orifice     Orifice connects chamber #1 to chamber #2 
% Chamber1Chamber2CheckValve  Check valuve that lets air flow from chamber #1 to chamber #2
% Chamber2Chamber1Orifice     Orifice connects chamber #2 to chamber #1 
% Chamber2Chamber1CheckValve  Check valuve that lets air flow from chamber #2 to chamber #1
% OutletCylinderOrifice       Orifice connects the cylinder to the tank
% OutletCylinderCheckValve    Check valuve that lets air flow from the cylinder to the thank
% Tank                        Storage vessel for the comperessed air
% OutletTankOrifice           Orifice connects the tank to the next connected unit
% OutletTankCheckValve        Check valuve that lets air flow from the tank to the next connected unit

%% General Constants
AOE.Rs                  = 288;          % For dry air 
AOE.gma                 = 1.4;          % air cp/cv
AOE.AtmPressure         = 101.3e3;      % 1 atm
AOE.AtmTemperature      = 293;          % 20 C Temperature of the air
%AOE.WaterTemperature    = 280;          % 7 C Temperature of the sea water      %Eric, Nov. 7/16
AOE.WaterTemperature    = 279; 
AOE.Cp                  = 1005;         %J / kgK for air @ 300 K          %Eric, Nov. 18/16
AOE.OrificeRatio        = inputs.OrificeRatio;                        %Eric, Nov. 25/16

%% Initial Temperature Coefficients (Estimates taken from '20 min Simulation Results.xlsx')
C2 = -2.24858675297471E-10;
C1 = 0.000547411355122799;
C = 258.803991051052;

%All coefficients used to approximate initial pressure are also given in '20 min Simulation Results.xlsx'

%Crack Pressure
AOE.Unit3.OutletTankCheckValve.CrackPressure                = inputs.Pressure; 

%% Unit1.Cylinder

AOE.Unit1.Cylinder.Length               = inputs.CylLength1;
AOE.Unit1.Cylinder.Diameter             = inputs.CylDiam1;
AOE.Unit1.Cylinder.CrossSectionalArea   = 0.25*pi*(AOE.Unit1.Cylinder.Diameter)^2;
AOE.Unit1.Cylinder.HeatConvection       = 0.2;  %This was referenced by Helen, Nov. 8/16
AOE.Unit1.Cylinder.EndStopDamping       = 5*10^6;
AOE.Unit1.Cylinder.EndStopStiffness     = 5*10^7;
AOE.Unit1.Cylinder.LowEndLimit          = 0.05*AOE.Unit1.Cylinder.Length;
AOE.Unit1.Cylinder.HighEndLimit         = 0.05*AOE.Unit1.Cylinder.Length;
AOE.Unit1.Cylinder.CoulombFrictionLimit = 0.4*AOE.Unit1.Cylinder.Diameter*1E3;      %This was referenced by Helen, Nov. 8/16
AOE.Unit1.Cylinder.CoulombFrictionGain  = 100000;
AOE.Unit1.Cylinder.InitialOffset        = 0.08418843;

%% Unit1.InletCylinderOrifice

AOE.Unit1.InletCylinderOrifice.Diameter                         = AOE.Unit1.Cylinder.Diameter*AOE.OrificeRatio; %Eric, Nov. 25/16 // Old value was: %0.35;
AOE.Unit1.InletCylinderOrifice.CrossSectionalArea               = 0.25*pi*(AOE.Unit1.InletCylinderOrifice.Diameter)^2;


%% Unit1.Chamber1

AOE.Unit1.Chamber1.InitialPistonPosition    = AOE.Unit1.Cylinder.Length/2;          %Eric, Nov. 25/16
AOE.Unit1.Chamber1.InitialPressure          = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.175;
AOE.Unit1.Chamber1.InitialTemperature       = C2*(AOE.Unit1.Chamber1.InitialPressure^2) + C1*AOE.Unit1.Chamber1.InitialPressure + C;
AOE.Unit1.Chamber1.InitialVolume            = AOE.Unit1.Cylinder.CrossSectionalArea * AOE.Unit1.Chamber1.InitialPistonPosition;
AOE.Unit1.Chamber1.InitialAirMass           = AOE.Unit1.Chamber1.InitialPressure * AOE.Unit1.Chamber1.InitialVolume/(AOE.Rs*AOE.Unit1.Chamber1.InitialTemperature);
%% Unit1.Chamber1Chamber2Orifice

AOE.Unit1.Chamber1Chamber2Orifice.Diameter                          = AOE.Unit1.InletCylinderOrifice.Diameter; %Eric, Nov. 14/16  // Old value was: % 0.5*AOE.Unit1.InletCylinderOrifice.Diameter;
AOE.Unit1.Chamber1Chamber2Orifice.CrossSectionalArea                = 0.25*pi*(AOE.Unit1.Chamber1Chamber2Orifice.Diameter)^2;


%% Unit1.Chamber2

AOE.Unit1.Chamber2.InitialPistonPosition    = AOE.Unit1.Cylinder.Length - AOE.Unit1.Chamber1.InitialPistonPosition;
AOE.Unit1.Chamber2.InitialPressure          = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.24;
AOE.Unit1.Chamber2.InitialTemperature       = C2*(AOE.Unit1.Chamber2.InitialPressure^2) + C1*AOE.Unit1.Chamber2.InitialPressure + C;
AOE.Unit1.Chamber2.InitialVolume            = AOE.Unit1.Cylinder.CrossSectionalArea * AOE.Unit1.Chamber2.InitialPistonPosition;
AOE.Unit1.Chamber2.InitialAirMass           = AOE.Unit1.Chamber2.InitialPressure * AOE.Unit1.Chamber2.InitialVolume/(AOE.Rs*AOE.Unit1.Chamber2.InitialTemperature);
AOE.Unit1.Chamber2.OutletPressure           = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.275; %2*AOE.Unit1.Chamber2.InitialPressure;

%% Unit1.OutletCylinderOrifice

AOE.Unit1.OutletCylinderOrifice.Diameter                        = AOE.Unit1.InletCylinderOrifice.Diameter;
AOE.Unit1.OutletCylinderOrifice.CrossSectionalArea              = 0.25*pi*(AOE.Unit1.OutletCylinderOrifice.Diameter)^2;

%% Unit1.Tank

AOE.Unit1.Tank.InitialPressure      = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.275;
AOE.Unit1.Tank.InitialTemperature   = C2*(AOE.Unit1.Tank.InitialPressure^2) + C1*AOE.Unit1.Tank.InitialPressure + C;
AOE.Unit1.Tank.NumAccumulators      = 6; %Eric, Nov. 21/16 (from AOE report)
AOE.Unit1.Tank.Radius               = 0.4572;  %Eric, Nov. 21/16 (from AOE report)
AOE.Unit1.Tank.LengthNoCaps         = 1.63;     %Eric, Nov. 21/16 (from AOE report)
AOE.Unit1.Tank.SurfaceArea          = AOE.Unit1.Tank.NumAccumulators*( AOE.Unit1.Tank.LengthNoCaps*pi*2*AOE.Unit1.Tank.Radius + 4*pi*AOE.Unit1.Tank.Radius );  %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Unit1.Tank.Volume               = AOE.Unit1.Tank.NumAccumulators*( pi*(AOE.Unit1.Tank.Radius^2)*AOE.Unit1.Tank.LengthNoCaps + (4/3)*pi*(AOE.Unit1.Tank.Radius^3) ); %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Unit1.Tank.InitialAirMass       = AOE.Unit1.Tank.InitialPressure * AOE.Unit1.Tank.Volume/(AOE.Rs*AOE.Unit1.Tank.InitialTemperature);
AOE.Unit1.Tank.HeatConvection       = AOE.Unit1.Cylinder.HeatConvection;

%% Unit1.OutletTankOrifice

AOE.Unit1.OutletTankOrifice.Diameter                        = AOE.Unit1.InletCylinderOrifice.Diameter ;
AOE.Unit1.OutletTankOrifice.CrossSectionalArea              = 0.25*pi*(AOE.Unit1.OutletTankOrifice.Diameter)^2;

%% Unit1.Pipe

AOE.Unit1.Pipe.InitialPressure          = AOE.Unit1.Tank.InitialPressure;
AOE.Unit1.Pipe.InitialTemperature       = AOE.Unit1.Tank.InitialTemperature;
AOE.Unit1.Pipe.Diameter                 = AOE.Unit1.OutletCylinderOrifice.Diameter;
AOE.Unit1.Pipe.CrossSectionalArea       = 0.25*pi*(AOE.Unit1.Pipe.Diameter)^2;
AOE.Unit1.Pipe.Length                   = 70;     %Eric, Nov. 25/16         %This was determined by Helen to be the distance between WECs
AOE.Unit1.Pipe.SurfaceArea              = pi*AOE.Unit1.Pipe.Diameter*AOE.Unit1.Pipe.Length;
AOE.Unit1.Pipe.Volume                   = AOE.Unit1.Pipe.CrossSectionalArea*AOE.Unit1.Pipe.Length;
AOE.Unit1.Pipe.InitialAirMass           = AOE.Unit1.Pipe.InitialPressure * AOE.Unit1.Pipe.Volume/(AOE.Rs*AOE.Unit1.Pipe.InitialTemperature);
AOE.Unit1.Pipe.HeatConvection           = AOE.Unit1.Tank.HeatConvection;

%% Unit1.OutletPipeOrifice

AOE.Unit1.OutletPipeOrifice.Diameter                 = AOE.Unit1.InletCylinderOrifice.Diameter;
AOE.Unit1.OutletPipeOrifice.CrossSectionalArea       = 0.25*pi*(AOE.Unit1.OutletPipeOrifice.Diameter)^2;

%*************************************************************************%


%% Unit2.Cylinder

AOE.Unit2.Cylinder.Length               = inputs.CylLength2;
AOE.Unit2.Cylinder.Diameter             = inputs.CylDiam2;
AOE.Unit2.Cylinder.CrossSectionalArea   = 0.25*pi*(AOE.Unit2.Cylinder.Diameter)^2;
AOE.Unit2.Cylinder.HeatConvection       = AOE.Unit1.Cylinder.HeatConvection;
AOE.Unit2.Cylinder.EndStopDamping       = AOE.Unit1.Cylinder.EndStopDamping;
AOE.Unit2.Cylinder.EndStopStiffness     = AOE.Unit1.Cylinder.EndStopStiffness;
AOE.Unit2.Cylinder.LowEndLimit          = 0.05*AOE.Unit2.Cylinder.Length;
AOE.Unit2.Cylinder.HighEndLimit         = 0.05*AOE.Unit2.Cylinder.Length;
AOE.Unit2.Cylinder.CoulombFrictionLimit = AOE.Unit1.Cylinder.CoulombFrictionLimit;
AOE.Unit2.Cylinder.CoulombFrictionGain  = AOE.Unit1.Cylinder.CoulombFrictionGain;

%% Unit2.Chamber1

AOE.Unit2.Chamber1.InitialPistonPosition    = AOE.Unit2.Cylinder.Length/2;
AOE.Unit2.Chamber1.InitialPressure          = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.335;
AOE.Unit2.Chamber1.InitialTemperature       = C2*(AOE.Unit2.Chamber1.InitialPressure ^2) + C1*AOE.Unit2.Chamber1.InitialPressure  + C;
AOE.Unit2.Chamber1.InitialVolume            = AOE.Unit2.Cylinder.CrossSectionalArea * AOE.Unit2.Chamber1.InitialPistonPosition;
AOE.Unit2.Chamber1.InitialAirMass           = AOE.Unit2.Chamber1.InitialPressure * AOE.Unit2.Chamber1.InitialVolume/(AOE.Rs*AOE.Unit2.Chamber1.InitialTemperature);

%% Unit2.Chamber1Chamber2Orifice

AOE.Unit2.Chamber1Chamber2Orifice.Diameter                      = AOE.Unit2.Cylinder.Diameter*AOE.OrificeRatio;
AOE.Unit2.Chamber1Chamber2Orifice.CrossSectionalArea            = 0.25*pi*(AOE.Unit2.Chamber1Chamber2Orifice.Diameter)^2;

%% Unit2.Chamber2

AOE.Unit2.Chamber2.InitialPistonPosition                        = AOE.Unit2.Cylinder.Length - AOE.Unit2.Chamber1.InitialPistonPosition;
AOE.Unit2.Chamber2.InitialPressure                              = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.456;
AOE.Unit2.Chamber2.InitialTemperature                           = C2*(AOE.Unit2.Chamber2.InitialPressure^2) + C1*AOE.Unit2.Chamber2.InitialPressure + C;
AOE.Unit2.Chamber2.InitialVolume                                = AOE.Unit2.Cylinder.CrossSectionalArea * AOE.Unit2.Chamber2.InitialPistonPosition;
AOE.Unit2.Chamber2.InitialAirMass                               = AOE.Unit2.Chamber2.InitialPressure * AOE.Unit2.Chamber2.InitialVolume/(AOE.Rs*AOE.Unit2.Chamber2.InitialTemperature);

%% Unit2.OutletCylinderOrifice

AOE.Unit2.OutletCylinderOrifice.Diameter                        = AOE.Unit2.Chamber1Chamber2Orifice.Diameter;
AOE.Unit2.OutletCylinderOrifice.CrossSectionalArea              = 0.25*pi*(AOE.Unit2.OutletCylinderOrifice.Diameter)^2;

%% Unit2.Tank

AOE.Unit2.Tank.InitialPressure                                  = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.515;
AOE.Unit2.Tank.InitialTemperature                               = C2*(AOE.Unit2.Tank.InitialPressure^2) + C1*AOE.Unit2.Tank.InitialPressure + C;
AOE.Unit2.Tank.NumAccumulators                                  = 6; %6; %Eric, Nov. 21/16 (from AOE report)
AOE.Unit2.Tank.Radius                                           = 0.4572;  %Eric, Nov. 21/16 (from AOE report)
AOE.Unit2.Tank.LengthNoCaps                                     = 1.63;     %Eric, Nov. 21/16 (from AOE report)
AOE.Unit2.Tank.SurfaceArea                                      = AOE.Unit2.Tank.NumAccumulators*( AOE.Unit2.Tank.LengthNoCaps*pi*2*AOE.Unit2.Tank.Radius + 4*pi*AOE.Unit2.Tank.Radius );  %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Unit2.Tank.Volume                                           = AOE.Unit2.Tank.NumAccumulators*( pi*(AOE.Unit2.Tank.Radius^2)*AOE.Unit2.Tank.LengthNoCaps + (4/3)*pi*(AOE.Unit2.Tank.Radius^3) ); %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Unit2.Tank.InitialAirMass                                   = AOE.Unit2.Tank.InitialPressure * AOE.Unit2.Tank.Volume/(AOE.Rs*AOE.Unit2.Tank.InitialTemperature);
AOE.Unit2.Tank.HeatConvection                                   = AOE.Unit2.Cylinder.HeatConvection;

%% Unit2.OutletTankOrifice

AOE.Unit2.OutletTankOrifice.Diameter                            = AOE.Unit2.Chamber1Chamber2Orifice.Diameter;
AOE.Unit2.OutletTankOrifice.CrossSectionalArea                  = 0.25*pi*(AOE.Unit2.OutletTankOrifice.Diameter)^2;

%% Unit2.Pipe

AOE.Unit2.Pipe.InitialPressure          = AOE.Unit2.Tank.InitialPressure;
AOE.Unit2.Pipe.InitialTemperature       = AOE.Unit2.Tank.InitialTemperature;
AOE.Unit2.Pipe.Diameter                 = AOE.Unit2.Chamber1Chamber2Orifice.Diameter;
AOE.Unit2.Pipe.CrossSectionalArea       = 0.25*pi*(AOE.Unit2.Pipe.Diameter)^2;
AOE.Unit2.Pipe.Length                   = AOE.Unit1.Pipe.Length ;                %Eric, Nov. 25/16         %This was determined by Helen to be the distance between WECs
AOE.Unit2.Pipe.SurfaceArea              = pi*AOE.Unit2.Pipe.Diameter*AOE.Unit2.Pipe.Length;
AOE.Unit2.Pipe.Volume                   = AOE.Unit2.Pipe.CrossSectionalArea*AOE.Unit2.Pipe.Length;
AOE.Unit2.Pipe.InitialAirMass           = AOE.Unit2.Pipe.InitialPressure * AOE.Unit2.Pipe.Volume/(AOE.Rs*AOE.Unit2.Pipe.InitialTemperature);
AOE.Unit2.Pipe.HeatConvection           = AOE.Unit2.Tank.HeatConvection;

%% Unit2.OutletPipeOrifice

AOE.Unit2.OutletPipeOrifice.Diameter                 = AOE.Unit2.Chamber1Chamber2Orifice.Diameter;
AOE.Unit2.OutletPipeOrifice.CrossSectionalArea       = 0.25*pi*(AOE.Unit2.OutletPipeOrifice.Diameter)^2;

%*************************************************************************%


%% Unit3.Cylinder

AOE.Unit3.Cylinder.Length               = inputs.CylLength3;
AOE.Unit3.Cylinder.Diameter             = inputs.CylDiam3;
AOE.Unit3.Cylinder.CrossSectionalArea   = 0.25*pi*(AOE.Unit3.Cylinder.Diameter)^2;
AOE.Unit3.Cylinder.HeatConvection       = AOE.Unit1.Cylinder.HeatConvection;
AOE.Unit3.Cylinder.EndStopDamping       = AOE.Unit1.Cylinder.EndStopDamping;
AOE.Unit3.Cylinder.EndStopStiffness     = AOE.Unit1.Cylinder.EndStopStiffness;
AOE.Unit3.Cylinder.LowEndLimit          = 0.05*AOE.Unit3.Cylinder.Length;
AOE.Unit3.Cylinder.HighEndLimit         = 0.05*AOE.Unit3.Cylinder.Length;
AOE.Unit3.Cylinder.CoulombFrictionLimit = AOE.Unit1.Cylinder.CoulombFrictionLimit;
AOE.Unit3.Cylinder.CoulombFrictionGain  = AOE.Unit1.Cylinder.CoulombFrictionGain;

%% Unit3.Chamber1

AOE.Unit3.Chamber1.InitialPistonPosition    = AOE.Unit3.Cylinder.Length/2;
AOE.Unit3.Chamber1.InitialPressure          = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.674;
AOE.Unit3.Chamber1.InitialTemperature       = C2*(AOE.Unit3.Chamber1.InitialPressure^2) + C1*AOE.Unit3.Chamber1.InitialPressure +C;
AOE.Unit3.Chamber1.InitialVolume            = AOE.Unit3.Cylinder.CrossSectionalArea * AOE.Unit3.Chamber1.InitialPistonPosition;
AOE.Unit3.Chamber1.InitialAirMass           = AOE.Unit3.Chamber1.InitialPressure * AOE.Unit3.Chamber1.InitialVolume/(AOE.Rs*AOE.Unit3.Chamber1.InitialTemperature);

%% Unit3.Chamber1Chamber2Orifice

AOE.Unit3.Chamber1Chamber2Orifice.Diameter                      = AOE.Unit3.Cylinder.Diameter*AOE.OrificeRatio;
AOE.Unit3.Chamber1Chamber2Orifice.CrossSectionalArea            = 0.25*pi*(AOE.Unit3.Chamber1Chamber2Orifice.Diameter)^2;

%% Unit3.Chamber2

AOE.Unit3.Chamber2.InitialPistonPosition                        = AOE.Unit3.Cylinder.Length - AOE.Unit3.Chamber1.InitialPistonPosition;
AOE.Unit3.Chamber2.InitialPressure                              = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.895;
AOE.Unit3.Chamber2.InitialTemperature                           = C2*(AOE.Unit3.Chamber2.InitialPressure^2) + C1*AOE.Unit3.Chamber2.InitialPressure + C;
AOE.Unit3.Chamber2.InitialVolume                                = AOE.Unit3.Cylinder.CrossSectionalArea * AOE.Unit3.Chamber2.InitialPistonPosition;
AOE.Unit3.Chamber2.InitialAirMass                               = AOE.Unit3.Chamber2.InitialPressure * AOE.Unit3.Chamber2.InitialVolume/(AOE.Rs*AOE.Unit3.Chamber2.InitialTemperature);

%% Unit3.OutletCylinderOrifice

AOE.Unit3.OutletCylinderOrifice.Diameter                        = AOE.Unit3.Chamber1Chamber2Orifice.Diameter;
AOE.Unit3.OutletCylinderOrifice.CrossSectionalArea              = 0.25*pi*(AOE.Unit3.OutletCylinderOrifice.Diameter)^2;


%% Unit3.Tank

AOE.Unit3.Tank.InitialPressure                                  = AOE.Unit3.OutletTankCheckValve.CrackPressure*0.99;
AOE.Unit3.Tank.InitialTemperature                               = C2*(AOE.Unit3.Tank.InitialPressure^2) + C1*AOE.Unit3.Tank.InitialPressure + C;
AOE.Unit3.Tank.NumAccumulators                                  = 6; %6; %Eric, Nov. 21/16 (from AOE report)
AOE.Unit3.Tank.Radius                                           = 0.4572;  %Eric, Nov. 21/16 (from AOE report)
AOE.Unit3.Tank.LengthNoCaps                                     = 1.63;     %Eric, Nov. 21/16 (from AOE report)
AOE.Unit3.Tank.SurfaceArea                                      = AOE.Unit3.Tank.NumAccumulators*( AOE.Unit3.Tank.LengthNoCaps*pi*2*AOE.Unit3.Tank.Radius + 4*pi*AOE.Unit3.Tank.Radius );  %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Unit3.Tank.Volume                                           = AOE.Unit3.Tank.NumAccumulators*( pi*(AOE.Unit3.Tank.Radius^2)*AOE.Unit3.Tank.LengthNoCaps + (4/3)*pi*(AOE.Unit3.Tank.Radius^3) ); %Changed by Eric, Nov. 18/16 in order to change tank to reflect data given by AOE
AOE.Unit3.Tank.InitialAirMass                                   = AOE.Unit3.Tank.InitialPressure * AOE.Unit3.Tank.Volume/(AOE.Rs*AOE.Unit3.Tank.InitialTemperature);
AOE.Unit3.Tank.HeatConvection                                   = AOE.Unit3.Cylinder.HeatConvection;

%% Unit3.OutletTankOrifice

AOE.Unit3.OutletTankOrifice.Diameter                            = AOE.Unit3.Chamber1Chamber2Orifice.Diameter;
AOE.Unit3.OutletTankOrifice.CrossSectionalArea                  = 0.25*pi*(AOE.Unit3.OutletTankOrifice.Diameter)^2;


