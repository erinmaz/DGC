

Hb_c = 12.8;  % MEASURED, g/dL(blood)
assume_cbf_ho = 1;

%WHOLE BRAIN MASK
bold_b_hc = 9.183166e+03 
bold_max_hc = 9.540108e+03
bold_b_ho = 9.320855e+03 
bold_max_ho = 9.441482e+03
cbf_b_hc = 7.213269e+03 
cbf_max_hc = 1.496266e+04
cbf_b_ho = 9.877841e+03 
cbf_min_ho = 9.552607e+03
cbf = 43.022343
totalvolume = 1210417.000000
includedvolume = 1211679.000000


%parenchyma
bold_b_hc = 9.408069e+03 
bold_max_hc = 9.747225e+03
bold_b_ho = 9.512972e+03 
bold_max_ho = 9.623780e+03
cbf_b_hc = 7.395899e+03 
cbf_max_hc = 1.537778e+04
cbf_b_ho = 1.010469e+04 
cbf_min_ho = 9.889834e+03
cbf = 42.277885
totalvolume = 1210417.000000
includedvolume = 953456.000000

% ET data
PetO2_hc = 107.355340
PetO2_b_hc = 105.618246
PetCO2_hc = 53.445172
PetCO2_b_hc = 42.032256
PetO2_ho = 386.292651
PetO2_b_ho = 100.431351
PetCO2_ho = 42.313548
PetCO2_b_ho = 41.215947

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