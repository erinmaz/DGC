

Hb_c = 12;  % MEASURED, g/dL(blood)
assume_cbf_ho = 1;

%WHOLE BRAIN MASK
bold_b_hc = 9.303200e+03 
bold_max_hc = 9.427433e+03
bold_b_ho = 9.243260e+03 
bold_max_ho = 9.333312e+03
cbf_b_hc = 8.425892e+03 
cbf_max_hc = 1.225480e+04
cbf_b_ho = 1.003232e+04 
cbf_min_ho = 9.155676e+03
cbf = 66.865980
totalvolume = 1525251.000000
includedvolume = 1528337.000000

%parenchyma
bold_b_hc = 9.514205e+03 
bold_max_hc = 9.633388e+03
bold_b_ho = 9.440568e+03 
bold_max_ho = 9.523099e+03
cbf_b_hc = 8.507363e+03 
cbf_max_hc = 1.235029e+04
cbf_b_ho = 1.006461e+04 
cbf_min_ho = 9.210992e+03
cbf = 65.287435
totalvolume = 1525251.000000
includedvolume = 1255626.000000

% ET data
PetO2_hc = 126.784135
PetO2_b_hc = 121.228683
PetCO2_hc = 48.145979
PetCO2_b_hc = 37.239223
PetO2_ho = 434.954539
PetO2_b_ho = 127.763500
PetCO2_ho = 38.219303
PetCO2_b_ho = 38.016794

alpha = 0.18 % ASSUMED
beta = 1.3 % ASSUMED
phi = 1.34 % mL(O2)/g(Hb)
epsilon = 0.0031 % mL(O2)/dL(blood)mmHg
Aagrad = 8; % mmHg, from Bulte 2012



[M,OEF,CMRO2] = DGC(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);

[Msteps,OEFsteps,CMRO2steps] = DGC_steps(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);