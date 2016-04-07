
%% Dual gas calibration based on Bulte et al, 2012 (with help interpreting from Avery Berman)
%  Estimates M from hypercapnia run, uses that M to estimate OEF/CMRO2 from
%  hyperoxia run
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


%  Outputs M, OEF, and CMRO2 
%  July 7, 2015
%  erinmaz@gmail.com


function [M,OEF,CMRO2] = DGC_steps(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_d_hc, ...
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
%SaO2_hc = getSaO2(PetO2_hc,Aagrad);

CaO2_b_hc = phi*Hb_c*SaO2_b_hc + (PetO2_b_hc-Aagrad)*epsilon;
CaO2_ho = phi*Hb_c*SaO2_ho + (PetO2_ho-Aagrad)*epsilon;
CaO2_b_ho = phi*Hb_c*SaO2_b_ho + (PetO2_b_ho-Aagrad)*epsilon;
%CaO2_hc = phi*Hb_c*SaO2_hc + (PetO2_hc-Aagrad)*epsilon;

%get M from hypercapnic data
M = ( bold_d_hc / bold_b_hc ) / ( 1 - ( cbf_d_hc / cbf_b_hc ) ^ ( alpha - beta ) );

%get OEF from hyperoxic data, using M from hypercapnia
dHb_c_fract = 1 - (cbf_b_ho/cbf_d_ho) + ( ( 1 - ( ( bold_d_ho / bold_b_ho ) / M ) ) * ( ( cbf_d_ho / cbf_b_ho ) ^ (-alpha) ) ) ^ ( 1 / beta );
Ca_Cv = ( dHb_c_fract - 1 - ( ( dHb_c_fract * CaO2_b_ho - CaO2_ho ) / ( phi * Hb_c ) ) ) * ( ( 1 - dHb_c_fract ) / ( phi * Hb_c ) ) ^ ( -1 );
OEF = SaO2_b_ho - ( ( ( CaO2_b_ho - ( Ca_Cv ) ) / ( phi * Hb_c ) ) );
CMRO2 = ( ( ( CaO2_b_hc + CaO2_b_ho ) / 2 ) * cbf * OEF ) / 100 * 39.34;

end