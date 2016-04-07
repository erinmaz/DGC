%Get SaO2 from PetO2
%Input: PetO2 and Alveolar?arterial gradient (Aagrad, usually assumed to be
%8mmHg as per Bulte 2012)
function SaO2 = getSaO2(PetO2,Aagrad)
PaO2 = PetO2-Aagrad; % from Bulte 2012
SaO2 = 1 / ( 1 + (23400 / (PaO2^3 + 150*PaO2))); % Severinghaus
end