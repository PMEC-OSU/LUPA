function [tau1,tau2] = mCDRLUPA8_bounce(x_wg,h,T)

% MCDRLUP8_BOUNCE
%
% [tau1,tau2] = mCDRLUPA8(x_wg,h,T);
%
% Calculates the time lag tau1 (s) for a linear wave in water depth 'h' (m)
% at period 'T' (s) to propagate from the wavemaker to x_wg.
%
% Also calculates the time lag tau2 (s) for that same linear wave to
% propagate from x_wg to the shoreline and back to x_wg again.
%
% Used for the mCDRLUPA8 project. Assumes the LWF and the concrete slab
% beach with a 1:12 slope.

% setup
x_wm = 0; % wavemaker face
x_wall = 76.224; % LWF onshore wall
x = linspace(x_wm,x_wall,1000); % x for LWF
h_beach = 12*0.3048; % height of beach at onshore end

% local water depth with 1:12 beach in LWF
h_x = max(0,min(h,h - (h_beach+(x-x_wall)/12))); 

% group velocity
[~,cg] = phase_speed(h_x,T);
cg(h_x==0)=0;

% travel time for a wave from x=0 to x=wg
% assumes wave gage is in the flat part of the basin
tau1 = (x_wg - x_wm)/cg(1);

% travel time for a wave from x=0 to shoreline and back again
j_wg = find(x >= x_wg,1,'first');
j_shore = find(h_x == 0,1,'first') - 1;
tau2 = 2*sum(mean(diff(x))./cg(j_wg:j_shore));

% done
end