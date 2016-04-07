%% Dual gas calibration based on Gauthier & Hoge, 2012
%  Solves the system of equations for the generalized calibration model,
%  assuming 1 hypercapnia run and 1 hyperoxia run 
%  Constraints are hard-coded (.01 < M < .2; 0.1 < OEF < 0.9)
%  Set up to do ROI analysis 

%  Inputs:

%  bold_b_hc - baseline BOLD signal during hypercapnia run
%  bold_max_hc - BOLD signal during hypercapnia
%  cbf_b_hc - baseline CBF signal during hypercapnia run
%  cbf_max_hc - CBF signal during hypercapnia

%  bold_b_ho - baseline BOLD signal during hyperoxia run
%  bold_max_ho - BOLD signal during hyperoxia
%  cbf_b_ho - baseline CBF signal during hyperoxia run
%  cbf_min_ho - CBF signal during hyperoxia

%  alpha, beta, phi, epsilon - see Gauthier & Hoge, 2012
%  PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, - end-tidal O2 values
%  during hypercapnia and hyperoxia runs, in mmHg

%  Aagrad - Alveolar-arterial gradient, in mmHg (see Bulte et al., 2012)
%  Hb_c - concentration of hemoglobin (from blood test, or 15 is a good guess)
%  cbf - resting CBF in ml/100g/min  
%  assume_ho_cbf - if set to 1, we ignore the hyperoxia CBF data and assume a decrease of
%  3.11 (from neurolens).


%  Outputs M, OEF, and CMRO2 and plots the calibration curves
%  July 7, 2015
%  erinmaz@gmail.com

function [M,OEF,CMRO2] = DGC(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_d_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c, cbf, assume_ho_cbf)

bold_d_hc = bold_max_hc-bold_b_hc;
bold_d_ho = bold_max_ho-bold_b_ho;

if assume_ho_cbf
    cbf_d_ho = cbf_b_ho - (cbf_b_ho*0.0311); %assume 3.11% decrease - from neurolens
end
SaO2_b_hc = getSaO2(PetO2_b_hc,Aagrad);
SaO2_ho = getSaO2(PetO2_ho,Aagrad);
SaO2_b_ho = getSaO2(PetO2_b_ho,Aagrad);
SaO2_hc = getSaO2(PetO2_hc,Aagrad);

CaO2_b_hc = phi*Hb_c*SaO2_b_hc + (PetO2_b_hc-Aagrad)*epsilon;
CaO2_ho = phi*Hb_c*SaO2_ho + (PetO2_ho-Aagrad)*epsilon;
CaO2_b_ho = phi*Hb_c*SaO2_b_ho + (PetO2_b_ho-Aagrad)*epsilon;
CaO2_hc = phi*Hb_c*SaO2_hc + (PetO2_hc-Aagrad)*epsilon;

syms Mvar OEFvar Mgraph

eqn1 = sym(Mvar == ( bold_d_hc / bold_b_hc ) / ...
    ( 1 - ( ( cbf_max_hc / cbf_b_hc ) ^ alpha ...
    * ( ( ( ( CaO2_b_hc * OEFvar ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b_hc / (phi * Hb_c ) )* ( 1 - OEFvar ) ) )  * ( cbf_b_hc / cbf_max_hc ) ) + ...
    ( ( 1 - ( CaO2_hc / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b_hc / (phi * Hb_c ) ) * (1 - OEFvar) ) ) ) )^ beta ) ) );

eqn2 = sym(Mvar == ( bold_d_ho / bold_b_ho ) / ...
    ( 1 - ( ( cbf_d_ho / cbf_b_ho ) ^ alpha ...
    * ( ( ( ( CaO2_b_ho * OEFvar ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b_ho / (phi * Hb_c ) )* ( 1 - OEFvar ) ) )  * ( cbf_b_ho / cbf_d_ho ) ) + ...
    ( ( 1 - ( CaO2_ho / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b_ho / (phi * Hb_c ) ) * (1 - OEFvar) ) ) ) )^ beta ) ) );

S = vpasolve(eqn1,eqn2,Mvar,OEFvar,[.01 .2; 0.1 0.9]);
M = S.Mvar;
OEF = S.OEFvar;
CMRO2 = (((CaO2_b_hc+CaO2_b_ho)/2)*cbf*OEF)/100*39.34;

%%% Brute force graph... I suspect there is a better way to do this
OEFarray = .1:0.005:.9;
MyM_hc = zeros(1,length(OEFarray));
MyM_ho = zeros(1,length(OEFarray));
for i = 1:length(OEFarray)
    
    sM = solve(Mgraph == ( bold_d_hc / bold_b_hc ) / ...
        ( 1 - ( ( cbf_max_hc / cbf_b_hc ) ^ alpha ...
        * ( ( ( ( CaO2_b_hc * OEFarray(i) ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b_hc / (phi * Hb_c ) )* ( 1 - OEFarray(i) ) ) )  * ( cbf_b_hc / cbf_max_hc ) ) + ...
        ( ( 1 - ( CaO2_hc / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b_hc / (phi * Hb_c ) ) * (1 - OEFarray(i)) ) ) ) )^ beta ) ), Mgraph);
    
    MyM_hc(i) = sM;
end

for i = 1:length(OEFarray)
    
    sM = solve(Mgraph == ( bold_d_ho / bold_b_ho ) / ...
        ( 1 - ( ( cbf_d_ho / cbf_b_ho ) ^ alpha ...
        * ( ( ( ( CaO2_b_ho * OEFarray(i) ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b_ho / (phi * Hb_c ) )* ( 1 - OEFarray(i) ) ) )  * ( cbf_b_ho / cbf_d_ho ) ) + ...
        ( ( 1 - ( CaO2_ho / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b_ho / (phi * Hb_c ) ) * (1 - OEFarray(i)) ) ) ) )^ beta ) ), Mgraph);
    
    MyM_ho(i) = sM;
end

figure
plot(MyM_hc)
hold
plot(MyM_ho,'r')



