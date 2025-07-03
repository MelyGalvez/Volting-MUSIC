clear;
clc;
close all;

% =====================================================================
% Analyse des données Volting actif
% =====================================================================

%% Variables
%  *********

% Partie I
% --------

data = readmatrix('DataMely19a.csv');
Debut_trace = 98;

% Partie II
% ---------

Debut = Debut_trace + 21;
Fin = Debut_trace + 56;
L = Fin - Debut;
Fs = 1000;

%% Code principal
%  **************

%% I - Etude temporelle
%  ********************

t = data(2:end, 1) - data(2, 1);

% Angles d'Euler
% --------------

E0 = data(2:end, 14);
E1 = data(2:end, 15);
E2 = data(2:end, 16);

% Accélérations linéaires
% -----------------------

Lx = data(2:end, 9);
Ly = data(2:end, 10);
Lz = data(2:end, 11);

% Vitesses angulaires
% -------------------

Vx = data(2:end, 6);
Vy = data(2:end, 7);
Vz = data(2:end, 8);

% Quaternions
% -----------

Qw = data(2:end, 2);
Qx = data(2:end, 3);
Qy = data(2:end, 4);
Qz = data(2:end, 5);

% Joy axis
% --------

JA0 = data(2:end, 12);
JA1 = data(2:end, 13);

JA0_A = data(2:end, 12);
JA1_A = data(2:end, 13);

% Angles de rotation quaternions
% ------------------------------

Theta = 2*acos(Qw)*180/pi;
QX = Qx*1/(sqrt(1-Qw.^2))*Theta;
QY = Qy*1/(sqrt(1-Qw.^2))*Theta;
QZ = Qz*1/(sqrt(1-Qw.^2))*Theta;

% Angles de rotation Euler-Quaternions
% ------------------------------------

Th = acos(1-2*(Qx.^2+Qy.^2))*180/pi;
Ph = atan2(Qx.*Qz-Qy.*Qw, Qy.*Qz+Qx.*Qw)*180/pi;
Ps = atan2(Qx.*Qz+Qy.*Qw, Qy.*Qz-Qx.*Qw)*180/pi;

% Angles de rotation Elémentaire-Quaternions
% ------------------------------------------

X = atan2(2*(Qy.*Qz+Qx.*Qw), 1-2*(Qx.^2+Qy.^2))*180/pi;
Y = asin(2*(Qy.*Qw-Qx.*Qz))*180/pi;
Z = atan2(2*(Qx.*Qy+Qz.*Qw), 1-2*(Qy.^2+Qz.^2))*180/pi;

% -------------------------------------------------------------------------

% Plots
% -----

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), QX(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), E0(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Th(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), X(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('X Quaterion', 'Euler 0', 'X Euler-Quaternions', 'X Elementaire-Quaternions');
title('Rotations autour de X en fonction du temps');
hold off;

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), QY(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), E1(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Ph(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Y(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Y Quaterion', 'Euler 1', 'Y Euler-Quaternions', 'Y Elementaire-Quaternions');
title('Rotations autour de Y en fonction du temps');
hold off;

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), QZ(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), E2(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Ps(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Z(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Z Quaterion', 'Euler 2', 'Z Euler-Quaternions', 'Z Elementaire-Quaternions');
title('Rotations autour de Z en fonction du temps');
hold off;

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), Theta(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Angle Theta (en °)');
legend('Theta');
title('Angle de rotation θ des quaternions en fonction du temps');
hold off;

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), Lx(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Ly(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Lz(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Accélération linéaire (en m/s²)');
legend('Lx', 'Ly', 'Lz');
title('Accélérations linéaires en fonction du temps');
hold off;

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), Vx(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Vy(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), Vz(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Vitesse angulaire (en rad/s)');
legend('Vx', 'Vy', 'Vz');
title('Vitesses angulaires en fonction du temps');
hold off;

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), JA0(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), JA1(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Commande Joy Axis');
legend('JA0', 'JA1');
title('Commande Joy Axis en fonction du temps');
hold off;

%% II - Etude Fréquentielle
%  ************************

t1 = data(Debut:Fin, 1) - data(Debut, 1);
Nfft = 2^nextpow2(L);
f_axis = Fs * (0:Nfft-1)/Nfft;

% Angles d'Euler
% --------------

E0 = data(Debut:Fin, 14);
E1 = data(Debut:Fin, 15);
E2 = data(Debut:Fin, 16);

F_E0 = abs(fft(E0, Nfft));
F_E1 = abs(fft(E1, Nfft));
F_E2 = abs(fft(E2, Nfft));

% Accélérations linéaires
% -----------------------

Lx = data(Debut:Fin, 9);
Ly = data(Debut:Fin, 10);
Lz = data(Debut:Fin, 11);

F_Lx = abs(fft(Lx, Nfft));
F_Ly = abs(fft(Ly, Nfft));
F_Lz = abs(fft(Lz, Nfft));

% Vitesses angulaires
% -------------------

Vx = data(Debut:Fin, 6);
Vy = data(Debut:Fin, 7);
Vz = data(Debut:Fin, 8);

F_Vx = abs(fft(Vx, Nfft));
F_Vy = abs(fft(Vy, Nfft));
F_Vz = abs(fft(Vz, Nfft));

% Quaternions
% -----------

Qw = data(Debut:Fin, 2);
Qx = data(Debut:Fin, 3);
Qy = data(Debut:Fin, 4);
Qz = data(Debut:Fin, 5);

F_Qw = abs(fft(Qw, Nfft));
F_Qx = abs(fft(Qx, Nfft));
F_Qy = abs(fft(Qy, Nfft));
F_Qz = abs(fft(Qz, Nfft));

% Joy axis
% --------

JA0 = data(Debut:Fin, 12);
JA1 = data(Debut:Fin, 13);

F_JA0 = abs(fft(JA0, Nfft));
F_JA1 = abs(fft(JA1, Nfft));

% Angles de rotation quaternions
% ------------------------------

Theta = 2*acos(Qw)*180/pi;
QX = Qx*1/(sqrt(1-Qw.^2))*Theta;
QY = Qy*1/(sqrt(1-Qw.^2))*Theta;
QZ = Qz*1/(sqrt(1-Qw.^2))*Theta;

F_QX = abs(fft(QX, Nfft));
F_QY = abs(fft(QY, Nfft));
F_QZ = abs(fft(QZ, Nfft));
F_Theta = abs(fft(Theta, Nfft));

% Angles de rotation Euler-Quaternions
% ------------------------------------

Th = acos(1-2*(Qx.^2+Qy.^2))*180/pi;
Ph = atan2(Qx.*Qz-Qy.*Qw, Qy.*Qz+Qx.*Qw)*180/pi;
Ps = atan2(Qx.*Qz+Qy.*Qw, Qy.*Qz-Qx.*Qw)*180/pi;

F_Th = abs(fft(Th, Nfft));
F_Ph = abs(fft(Ph, Nfft));
F_Ps = abs(fft(Ps, Nfft));

% Angles de rotation Elémentaire-Quaternions
% ------------------------------------------

X = atan2(2*(Qy.*Qz+Qx.*Qw), 1-2*(Qx.^2+Qy.^2))*180/pi;
Y = asin(2*(Qy.*Qw-Qx.*Qz))*180/pi;
Z = atan2(2*(Qx.*Qy+Qz.*Qw), 1-2*(Qy.^2+Qz.^2))*180/pi;

F_X = abs(fft(X, Nfft));
F_Y = abs(fft(Y, Nfft));
F_Z = abs(fft(Z, Nfft));

% -------------------------------------------------------------------------

% Plots
% -----

figure;
subplot(3,2,1);
hold on;
plot(t1, QX);
plot(t1, E0);
plot(t1, Th);
plot(t1, X);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('X Quaterion', 'Euler 0', 'X Euler-Quaternions', 'X Elementaire-Quaternions');
title('Rotations autour de X en fonction du temps');
hold off;

subplot(3,2,2);
hold on;
plot(f_axis, F_QX);
plot(f_axis, F_E0);
plot(f_axis, F_Th);
plot(f_axis, F_X);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('X Quaterion', 'Euler 0', 'X Euler-Quaternions', 'X Elementaire-Quaternions');
title('Transformée de Fourier des rotations autour de X');
hold off;

subplot(3,2,3);
hold on;
plot(t1, QY);
plot(t1, E1);
plot(t1, Ph);
plot(t1, Y);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Y Quaterion', 'Euler 1', 'Y Euler-Quaternions', 'Y Elementaire-Quaternions');
title('Rotations autour de Y en fonction du temps');
hold off;

subplot(3,2,4);
hold on;
plot(f_axis, F_QY);
plot(f_axis, F_E1);
plot(f_axis, F_Ph);
plot(f_axis, F_Y);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Y Quaterion', 'Euler 1', 'Y Euler-Quaternions', 'Y Elementaire-Quaternions');
title('Transformée de Fourier des rotations autour de Y');
hold off;

subplot(3,2,5);
hold on;
plot(t1, QZ);
plot(t1, E2);
plot(t1, Ps);
plot(t1, Z);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Z Quaterion', 'Euler 2', 'Z Euler-Quaternions', 'Z Elementaire-Quaternions');
title('Rotations autour de Z en fonction du temps');
hold off;

subplot(3,2,6);
hold on;
plot(f_axis, F_QZ);
plot(f_axis, F_E2);
plot(f_axis, F_Ps);
plot(f_axis, F_Z);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Z Quaterion', 'Euler 2', 'Z Euler-Quaternions', 'Z Elementaire-Quaternions');
title('Transformée de Fourier des rotations autour de Z en fonction du temps');
hold off;

figure;
subplot(2,2,1);
hold on;
plot(t1, Lx);
plot(t1, Ly);
plot(t1, Lz);
xlabel("Temps (en s)");
ylabel('Accélération linéaire (en m/s²)');
legend('Lx', 'Ly', 'Lz');
title('Accélérations linéaires en fonction du temps');
hold off;

subplot(2,2,2);
hold on;
plot(f_axis, F_Lx);
plot(f_axis, F_Ly);
plot(f_axis, F_Lz);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Lx', 'Ly', 'Lz');
title('Transformée de Fourier des accélérations linéaires');
hold off;

subplot(2,2,3);
hold on;
plot(t1, Vx);
plot(t1, Vy);
plot(t1, Vz);
xlabel("Temps (en s)");
ylabel('Vitesse angulaire (en rad/s)');
legend('Vx', 'Vy', 'Vz');
title('Vitesses angulaires en fonction du temps');
hold off;

subplot(2,2,4);
hold on;
plot(f_axis, F_Vx);
plot(f_axis, F_Vy);
plot(f_axis, F_Vz);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Vx', 'Vy', 'Vz');
title('Transformée de Fourier des Vitesse angulaires');
hold off;

figure;
subplot(2,2,1);
hold on;
plot(t1, Theta);
xlabel("Temps (en s)");
ylabel('Angle Theta (en °)');
legend('Theta');
title('Angle de rotation θ des quaternions en fonction du temps');
hold off;

subplot(2,2,2);
hold on;
plot(f_axis, F_Theta);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Theta');
title('Transformée de Fourier de l-angle de rotation θ des quaternions');
hold off;

subplot(2,2,3);
hold on;
plot(t1, JA0);
plot(t1, JA1);
xlabel("Temps (en s)");
ylabel('Distance main-support (en m)');
legend('JA0', 'JA1');
title('Commande Joy Axis en fonction du temps');
hold off;

subplot(2,2,4);
hold on;
plot(f_axis, F_JA0);
plot(f_axis, F_JA1);
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('JA0', 'JA1');
title('Transformée de Fourier de Joy Axis');
hold off;

%% III - Détermination de l'instant de la maîtrise
%  ***********************************************

% On initialse le delta t1 entre deux mesures.
delta_t = zeros(length(t),1);

% On initialise les delta JA entre deux mesures.
delta_JA0 = zeros(length(t),1);
delta_JA1 = zeros(length(t),1);

% On calcule les delta t1 et JA entre deux mesures.
for k = 2:(length(t))
    delta_t(k-1) = t(k) - t(k-1);
    delta_JA0(k-1) = JA0_A(k) - JA0_A(k-1);
    delta_JA1(k-1) = JA1_A(k) - JA1_A(k-1);
end

% On calcule les dérivés avec le rapport entre les delta et les delta t.
d_JA0 = delta_JA0./delta_t;
d_JA1 = delta_JA1./delta_t;

figure;
subplot(1,2,1);
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), JA0_A(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), JA1_A(Debut_trace:end));
xlabel("Temps (en s)");
ylabel('Distance main-support (en m)');
legend('JA0', 'JA1');
title('Commande Joy Axis en fonction du temps');
hold off;

subplot(1,2,2);
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), d_JA0(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), d_JA1(Debut_trace:end));
xlabel('Temps (en s)');
ylabel('Dérivée du Joy Axis');
legend('JA0', 'JA1');
title('Maîtrise du buste - Analyse du Joy Axis');

figure;
hold on;
plot(t(Debut_trace:end)-t(Debut_trace), d_JA0(Debut_trace:end));
plot(t(Debut_trace:end)-t(Debut_trace), d_JA1(Debut_trace:end));
xlabel('Temps (en s)');
ylabel('Dérivée du Joy Axis');
legend('JA0', 'JA1');
title('Maîtrise du buste - Analyse du Joy Axis');