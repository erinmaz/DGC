
%values for MMD_C01, although I haven't actually gotten the PetO2 data out
%yet. Using targets on checklists
bold_b_hc = 1.040436e+04 
bold_max_hc = 1.063392e+04
bold_b_ho = 1.041131e+04 
bold_max_ho = 1.058065e+04
cbf_b_hc = 8.524009e+03 
cbf_max_hc = 1.262068e+04
cbf_b_ho = 9.791200e+03 
cbf_min_ho = 8.769439e+03
CBF = 40.750800
totalvolume = 1501806.000000
includedvolume = 792294.000000

alpha = 0.18 % ASSUMED
beta = 1.3 % ASSUMED

phi = 1.34 % mL(O2)/g(Hb)
epsilon = 0.0031 % mL(O2)/dL(blood)mmHg

PetO2_b = 115 % mmHg, 
PetO2_ho = 415 % mmHg,
PetO2_hc = 115  % mmHg, 
Aagrad = 8; % mmHg, from Bulte 2012
Hb_c = 15.5;  % MEASURED, g/dL(blood)
cbf = 40.751;
assume_cbf_ho = 1;
[M,OEF,CMRO2] = DGC(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b, PetO2_hc, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);
