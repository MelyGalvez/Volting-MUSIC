function [M_BJ] = Maitrise_Buste_Jerk(Nech, S, A, t)
% Maîtrise du buste - Méthode 1 - Jerk
%   Effectue la méthode 2 pour la maîtrise du bust, renvoie la liste des
%   temps de maîtrise.

delta_A = diff(A);
delta_t = diff(t);
delta_t(delta_t == 0) = eps;
d_A = delta_A ./ delta_t;

M_BJ = zeros(length(A), 1);
Q = floor(length(d_A) / Nech);

for k = 1:Q
    idx_start = (k-1)*Nech + 1;
    idx_end = k*Nech;
    if mean(abs(d_A(idx_start:idx_end))) < S
        M_BJ(idx_start:idx_end) = 1;
    end
end
if Q*Nech < length(d_A)
    idx_start = Q*Nech + 1;
    idx_end = length(d_A);
    if mean(abs(d_A(idx_start:idx_end))) < S
        M_BJ(idx_start:idx_end) = 1;
    end
end

end
