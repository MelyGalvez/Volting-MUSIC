function [M_MA] = Maitrise_Mains_Autocorrelation(Nech, S, D)
% Maîtrise des mains - Méthode 1 - Autocorrélation
%   Effectue la méthode 1 pour la maîtrise des mains, renvoie la liste des
%   temps de maîtrise.

Q = floor(length(D)/Nech);

M_MA = zeros(length(D),1);

for k = 1:Q
    F_D = abs(fft(D(((k-1)*Nech+1):k*Nech), Q));
    c = xcorr(F_D);
    c = c/max(abs(c))*100;
    if mean(c) < S
        M_MA((k-1)*Nech+1:k*Nech) = 1;
    end
end

F_D = abs(fft(D(Q*Nech+1:end), Q));
c = xcorr(F_D(Q*Nech+1:end));
c = c/max(abs(c))*100;

if mean(c) < S
        M_MA(Q*Nech+1:end) = 1;
end