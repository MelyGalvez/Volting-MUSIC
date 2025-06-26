function [M_BI] = Maitrise_Buste_Intercorrelation_Signal_theorique(Nech, varA, I, S, A)
% Maîtrise Au buste - Méthode 2 - Intercorrelation signal théorique
%   Effectue la méthode 2 pour la maîtrise du buste, renvoie la liste des
%   temps de maîtrise.

Fs = 1000;
M_BI = zeros(length(A), 1);

Q = floor(length(A) / Nech);

for k = 1:Q
    idx_start = (k-1)*Nech + 1;
    idx_end = k*Nech;
    
    A_seg = A(idx_start:idx_end);
    
    BA = randn(size(A_seg)) * varA;
    I_end = min(idx_start + I - 1, length(A)); 
    CAm = mean(A(idx_start:I_end));
    CA = ones(size(A_seg)) * CAm;
    
    t = (0:length(A_seg)-1)' / Fs;
    Sin = sin(pi * t);
    
    A_th = CA + BA + Sin;
    
    cA = xcorr(A_seg, A_th);
    cA = cA / max(cA) * 100;
    
    if median(cA) > S
        M_BI(idx_start:idx_end) = 1;
    end
end

if Q * Nech < length(A)
    idx_start = Q * Nech + 1;
    idx_end = length(A);
    
    A_seg = A(idx_start:idx_end);
    
    BA = randn(size(A_seg)) * varA;
    I_end = min(idx_start + I - 1, length(A)); 
    CAm = mean(A(idx_start:I_end));
    CA = ones(size(A_seg)) * CAm;
    
    t = (0:length(A_seg)-1)' / Fs;
    Sin = sin(pi * t);
    
    A_th = CA + BA + Sin;
    
    cA = xcorr(A_seg, A_th);
    cA = cA / max(cA) * 100;
    
    if median(cA) > S
        M_BI(idx_start:idx_end) = 1;
    end
end

end