

bold_b_hc = 100  % MEASURED
bold_d_hc = 2.206  % MEASURED

cbf_b_hc = 40.751  % MEASURED
cbf_d_hc =  59.2240 % MEASURED


bold_b_ho = 100  % MEASURED
bold_d_ho = 1.623  % MEASURED

cbf_b_ho = 40.751  % MEASURED
cbf_d_ho = 39.4836 % MEASURED (corresponds to -3.11 from neurolens)

alpha = 0.18 % ASSUMED
beta = 1.3 % ASSUMED

phi = 1.34 % mL(O2)/g(Hb)
epsilon = 0.0031 % mL(O2)/dL(blood)mmHg

PetO2_b = 115 % mmHg, MEASURED
PetO2_ho = 615 % mmHg, MEASURED
PetO2_hc = 115  % mmHg, MEASURED
Aagrad = 8; % mmHg, from Bulte 2012
SaO2_b = getSaO2(PetO2_b,Aagrad);
SaO2_ho = getSaO2(PetO2_ho,Aagrad);
SaO2_hc = getSaO2(PetO2_hc,Aagrad);

Hb_c = 15  % MEASURED, g/dL(blood)

CaO2_b = phi*Hb_c*SaO2_b + (PetO2_b-Aagrad)*epsilon
CaO2_ho = phi*Hb_c*SaO2_ho + (PetO2_ho-Aagrad)*epsilon
CaO2_hc = phi*Hb_c*SaO2_hc + (PetO2_hc-Aagrad)*epsilon

syms M OEF


eqn1 = M == ( bold_d_hc / bold_b_hc ) / ...
( 1 - ( ( cbf_d_hc / cbf_b_hc ) ^ alpha ...
* ( ( ( ( CaO2_b * OEF ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b / (phi * Hb_c ) )* ( 1 - OEF ) ) )  * ( cbf_b_hc / cbf_d_hc ) ) + ...
( ( 1 - ( CaO2_hc / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b / (phi * Hb_c ) ) * (1 - OEF) ) ) ) )^ beta ) );

eqn2 = M == ( bold_d_ho / bold_b_ho ) / ...
( 1 - ( ( cbf_d_ho / cbf_b_ho ) ^ alpha ...
* ( ( ( ( CaO2_b * OEF ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b / (phi * Hb_c ) )* ( 1 - OEF ) ) )  * ( cbf_b_ho / cbf_d_ho ) ) + ...
( ( 1 - ( CaO2_ho / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b / (phi * Hb_c ) ) * (1 - OEF) ) ) ) )^ beta ) );

S = vpasolve(eqn1,eqn2,M,OEF,[0 1; 0 1]);
S.M
S.OEF



%%% For a graph... although I suspect there is a better way to do this

OEF = [.1:0.005:.9];
for i = 1:length(OEF)

sM = solve(M == ( bold_d_hc / bold_b_hc ) / ...
( 1 - ( ( cbf_d_hc / cbf_b_hc ) ^ alpha ...
* ( ( ( ( CaO2_b * OEF(i) ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b / (phi * Hb_c ) )* ( 1 - OEF(i) ) ) )  * ( cbf_b_hc / cbf_d_hc ) ) + ...
( ( 1 - ( CaO2_hc / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b / (phi * Hb_c ) ) * (1 - OEF(i)) ) ) ) )^ beta ) ), M);

MyM_hc(i) = sM;
end

for i = 1:length(OEF)

sM = solve(M == ( bold_d_ho / bold_b_ho ) / ...
( 1 - ( ( cbf_d_ho / cbf_b_ho ) ^ alpha ...
* ( ( ( ( CaO2_b * OEF(i) ) / ( phi * Hb_c ) ) /  ( 1 -  ( ( CaO2_b / (phi * Hb_c ) )* ( 1 - OEF(i) ) ) )  * ( cbf_b_ho / cbf_d_ho ) ) + ...
( ( 1 - ( CaO2_ho / ( phi * Hb_c ) ) ) / ( 1 - ( ( CaO2_b / (phi * Hb_c ) ) * (1 - OEF(i)) ) ) ) )^ beta ) ), M);

MyM_ho(i) = sM;
end

figure
plot(MyM_hc)
hold
plot(MyM_ho,'r')


