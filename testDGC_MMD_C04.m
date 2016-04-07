

Hb_c = 14.3;  % MEASURED, g/dL(blood)
assume_cbf_ho = 1;

%WHOLE BRAIN MASK
bold_b_hc = 9.346935e+03 
bold_max_hc = 9.602929e+03
bold_b_ho = 9.412384e+03 
bold_max_ho = 9.500178e+03
cbf_b_hc = 7.839629e+03 
cbf_max_hc = 1.300999e+04
cbf_b_ho = 9.850052e+03 
cbf_min_ho = 7.746427e+03
cbf = 36.100432
totalvolume = 1394970.000000
includedvolume = 1395525.000000


%parenchyma
bold_b_hc = 9.346946e+03 
bold_max_hc = 9.585830e+03
bold_b_ho = 9.426734e+03 
bold_max_ho = 9.506211e+03
cbf_b_hc = 7.447274e+03 
cbf_max_hc = 1.311893e+04
cbf_b_ho = 9.387016e+03 
cbf_min_ho = 7.184698e+03
cbf = 34.454674
totalvolume = 1394970.000000
includedvolume = 1091472.000000

% ET data
PetO2_hc = 119.298270
PetO2_b_hc = 107.242973
PetCO2_hc = 48.619641
PetCO2_b_hc = 38.310237
PetO2_ho = 400 %estimated - trace very messy
PetO2_b_ho = 100 % estimated - trace very messy

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