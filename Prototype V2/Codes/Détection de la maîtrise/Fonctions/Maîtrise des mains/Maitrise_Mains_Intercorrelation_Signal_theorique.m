function [M_MI] = Maitrise_Mains_Intercorrelation_Signal_theorique(Nech, varD, I, S, D)
% Maîtrise des mains - Méthode 2 - Intercorrelation signal théorique
%   Effectue la méthode 2 pour la maîtrise des mains, renvoie la liste des
%   temps de maîtrise.

Fs = 1000;
M_MI = zeros(length(D), 1);

Q = floor(length(D) / Nech);

for k = 1:Q
    idx_start = (k-1)*Nech + 1;
    idx_end = k*Nech;
    
    D_seg = D(idx_start:idx_end);
    
    Bd = randn(size(D_seg)) * varD;
    I_end = min(idx_start + I, length(D));
    Cdm = mean(D(idx_start:I_end));
    Cd = ones(size(D_seg)) * Cdm;
    
    t = (0:length(D_seg)-1)' / Fs;
    Sin = sin(pi * t);
    
    D_th = Cd + Bd + Sin;
    
    cD = xcorr(D_seg, D_th);
    cD = cD / max(cD) * 100;
    
    if median(cD) > S
        M_MI(idx_start:idx_end) = 1;
    end
end

if Q*Nech < length(D)
    idx_start = Q*Nech + 1;
    idx_end = length(D);
    
    D_seg = D(idx_start:idx_end);
    
    Bd = randn(size(D_seg)) * varD;
    I_end = min(idx_start + I, length(D)); 
    Cdm = mean(D(idx_start:I_end));
    Cd = ones(size(D_seg)) * Cdm;
    
    t = (0:length(D_seg)-1)' / Fs;
    Sin = sin(pi * t);
    
    D_th = Cd + Bd + Sin;
    
    cD = xcorr(D_seg, D_th);
    cD = cD / max(cD) * 100;
    
    if median(cD) > S
        M_MI(idx_start:idx_end) = 1;
    end
end

end