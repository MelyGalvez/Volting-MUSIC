clear;
clc;
close all;

% =====================================================================
% Application des fonctions de maîtrise
% =====================================================================

%% Variables utiles
%  ****************

data = readmatrix('19.csv');

t = data(2:end, 1) - data(2, 1);

Ax = data(2:end, 8);
Ay = data(2:end, 9);
Az = data(2:end, 10);

D1 = data(2:end, 22);
D2 = data(2:end, 23);

%% Maîtrise des mains
%  ******************

% Méthode 1 - Autocorrelation
% ---------------------------

Nech = 16;
S = 20;

M_MA_1 = Maitrise_Mains_Autocorrelation(Nech, S, D1);
M_MA_2 = Maitrise_Mains_Autocorrelation(Nech, S, D2);

figure;
subplot(2,1,1);
hold on;
plot(t,D1);
plot(t,D2);
xlabel('Temps (en s)')
ylabel('Distance main-support (en m)')
title('Distances entre les mains et le support en fonction du temps');
hold off;

subplot(2,1,2);
hold on;
plot(t,M_MA_1);
plot(t,M_MA_2);
xlabel('Temps (en s)')
ylabel('Maîtrise')
title('Maîtrise des mains - Méthode 1 - Autocorrélation');
hold off;

% Méthode 2 - Intercorrelation signal théorique
% ---------------------------------------------

Nech = 32;
varD = 60;
I = 10;
S = 50;

M_MI_1 = Maitrise_Mains_Intercorrelation_Signal_theorique(Nech, varD, I, S, D1);
M_MI_2 = Maitrise_Mains_Intercorrelation_Signal_theorique(Nech, varD, I, S, D2);

figure;
subplot(2,1,1);
hold on;
plot(t,D1);
plot(t,D2);
xlabel('Temps (en s)')
ylabel('Distance main-support (en m)')
title('Distances entre les mains et le support en fonction du temps');
hold off;

subplot(2,1,2);
hold on;
plot(t,M_MI_1);
plot(t,M_MI_2);
xlabel('Temps (en s)')
ylabel('Maîtrise')
title('Maîtrise des mains - Méthode 2 - Intercorrelation signal théorique');
hold off;

%% Maîtrise du buste
%  *****************

% Méthode 1 - Jerk
% ----------------

Nech = 16;
S = 10;

M_BJ_x = Maitrise_Buste_Jerk(Nech, S, Ax, t);
M_BJ_y = Maitrise_Buste_Jerk(Nech, S, Ay, t);
M_BJ_z = Maitrise_Buste_Jerk(Nech, S, Az, t);

figure;
subplot(2,1,1);
hold on;
plot(t,Ax);
plot(t,Ay);
plot(t,Az);
xlabel('Temps (en s)')
ylabel('Accélération angulaire (en rad/s^2)');
legend('Ax', 'Ay', 'Az');
title('Accélérations angulaires en fonction du temps');
hold off;

subplot(2,1,2);
hold on;
plot(t, M_BJ_x);
plot(t, M_BJ_y);
plot(t, M_BJ_z);
xlabel('Temps (en s)')
ylabel('Maîtrise')
legend('Ax', 'Ay', 'Az');
title('Maîtrise du buste - Méthode 1 - Jerk');
hold off;

% Méthode 2 - Intercorrelation signal théorique
% ---------------------------------------------

Nech = 32;
varA = 60;
I = 10;
S = 25;

M_BI_x = Maitrise_Buste_Intercorrelation_Signal_theorique(Nech, varA, I, S, Ax);
M_BI_y = Maitrise_Buste_Intercorrelation_Signal_theorique(Nech, varA, I, S, Ay);
M_BI_z = Maitrise_Buste_Intercorrelation_Signal_theorique(Nech, varA, I, S, Az);

figure;
subplot(2,1,1);
hold on;
plot(t,Ax);
plot(t,Ay);
plot(t,Az);
xlabel('Temps (en s)')
ylabel('Accélération angulaire (en rad/s^2)');
legend('Ax', 'Ay', 'Az');
title('Accélérations angulaires en fonction du temps');
hold off;

subplot(2,1,2);
hold on;
plot(t, M_BI_x);
plot(t, M_BI_y);
plot(t, M_BI_z);
xlabel('Temps (en s)')
ylabel('Maîtrise')
legend('Ax', 'Ay', 'Az');
title('Maîtrise du buste - Méthode 2 - Intercorrelation signal théorique');
hold off;
