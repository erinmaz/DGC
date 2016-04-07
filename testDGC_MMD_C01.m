
%These values are output by the script getHCHOactmask_formatlab.sh

%VALUES FROM VOXELS THAT ARE ACTIVATED IN BOTH HC AND HO
% bold_b_hc = 1.040436e+04 
% bold_max_hc = 1.063392e+04
% bold_b_ho = 1.041131e+04 
% bold_max_ho = 1.058065e+04
% cbf_b_hc = 8.524009e+03 
% cbf_max_hc = 1.262068e+04
% cbf_b_ho = 9.791200e+03 
% cbf_min_ho = 8.769439e+03
% CBF = 40.750800
% totalvolume = 1501806.000000
% includedvolume = 792294.000000



% These values are ouput by the script inputtomatlabDGC_selectmask.sh

%WHOLE BRAIN MASK
bold_b_hc = 9.582055e+03 
bold_max_hc = 9.772084e+03
bold_b_ho = 9.556678e+03 
bold_max_ho = 9.670401e+03
cbf_b_hc = 7.915310e+03 
cbf_max_hc = 1.193692e+04
cbf_b_ho = 9.065470e+03 
cbf_min_ho = 8.061649e+03
cbf = 38.341189
totalvolume = 1501806.000000
includedvolume = 1504636.000000

% PARENCHYMA
bold_b_hc = 9.752896e+03 
bold_max_hc = 9.933630e+03
bold_b_ho = 9.707444e+03 
bold_max_ho = 9.811225e+03
cbf_b_hc = 7.971705e+03 
cbf_max_hc = 1.212124e+04
cbf_b_ho = 9.033243e+03 
cbf_min_ho = 8.038638e+03
cbf = 37.550634
totalvolume = 1501806.000000
includedvolume = 1233548.000000



alpha = 0.18 % ASSUMED
beta = 1.3 % ASSUMED
Aagrad = 8; % mmHg, ASSUMED from Bulte 2012
phi = 1.34 % mL(O2)/g(Hb), ASSUMED
epsilon = 0.0031 % mL(O2)/dL(blood)mmHg, ASSUMED

% From respiract data - matlab code, needs to be finalized and data needs
% to be saved.
% raw_respiract2bbb and findtroughs

PetO2_hc = 111.987677
PetO2_b_hc = 103.395193
PetCO2_hc = 52.109798
PetCO2_b_hc = 43.227156
PetO2_ho = 405.822970
PetO2_b_ho = 107.673022
PetCO2_ho = 42.315679
PetCO2_b_ho = 41.823141

% from blood test reports/Yuhan's spreadsheet
Hb_c = 15.5;  % MEASURED, g/dL(blood)

assume_cbf_ho = 1;

[M,OEF,CMRO2] = DGC(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);

[Msteps,OEFsteps,CMRO2steps] = DGC_steps(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);


assume_cbf_ho = 0; %when I do this, both implementations seem to underestimate CMRO2 and OEF. Will depend on the actual cbf HO data though. 

[M2,OEF2,CMRO22] = DGC(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);

[Msteps2,OEFsteps2,CMRO2steps2] = DGC_steps(bold_b_hc, bold_max_hc, cbf_b_hc, cbf_max_hc, ...
    bold_b_ho, bold_max_ho, cbf_b_ho, cbf_min_ho, alpha, beta, phi, epsilon, ...
    PetO2_b_hc, PetO2_hc, PetO2_b_ho, PetO2_ho, Aagrad, Hb_c,cbf,assume_cbf_ho);


