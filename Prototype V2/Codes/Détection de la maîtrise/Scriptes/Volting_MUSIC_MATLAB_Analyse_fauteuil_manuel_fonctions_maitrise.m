clear;
clc;
close all;

% =====================================================================
% Tracés des études temporelles et fréquentielles avec la méthode de la
% maîtrise ============================================================
% ========

%% Variables
%  *********

% Partie I
% --------

data = readmatrix('1.csv');

% Partie II
% ---------

Debut = 43;
Fin = 87;
L = Fin - Debut;
Fs = 1000;

% Partie III
% ----------

varianceD = 1;
A = 10;
Phase = 30;
C_Indice = 30;
varianceA = 0.5;

%% Code principal
%  **************

%% I - Etude temporelle
%  ********************

t = data(2:end, 1) - data(2, 1);

% Angles d'Euler
% --------------

Ex = data(2:end, 2);
Ey = data(2:end, 3);
Ez = data(2:end, 4);

% Accélérations linéaires
% -----------------------

Lx = data(2:end, 5);
Ly = data(2:end, 6);
Lz = data(2:end, 7);

% Accélérations angulaires
% ------------------------

Ax = data(2:end, 8);
Ay = data(2:end, 9);
Az = data(2:end, 10);

% Vitesses angulaires
% -------------------

Vx = data(2:end, 11);
Vy = data(2:end, 12);
Vz = data(2:end, 13);

% Champs magnétiques
% ------------------

Mx = data(2:end, 14);
My = data(2:end, 15);
Mz = data(2:end, 16);

% Quaternions
% -----------

Qw = data(2:end, 17);
Qx = data(2:end, 18);
Qy = data(2:end, 19);
Qz = data(2:end, 20);

% Température
% -----------

T = data(2:end, 21);

% Distances entre les mains et le support
% ---------------------------------------

D1 = data(2:end, 22);
D2 = data(2:end, 23);

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
plot(t, QX);
plot(t, Ex);
plot(t, Th);
plot(t, X);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('X Quaterion', 'X Euler', 'X Euler-Quaternions', 'X Elementaire-Quaternions');
title('Rotations autour de X en fonction du temps');
hold off;

figure;
hold on;
plot(t, QY);
plot(t, Ey);
plot(t, Ph);
plot(t, Y);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Y Quaterion', 'Y Euler', 'Y Euler-Quaternions', 'Y Elementaire-Quaternions');
title('Rotations autour de Y en fonction du temps');
hold off;

figure;
hold on;
plot(t, QZ);
plot(t, Ez);
plot(t, Ps);
plot(t, Z);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Z Quaterion', 'Z Euler', 'Z Euler-Quaternions', 'Z Elementaire-Quaternions');
title('Rotations autour de Z en fonction du temps');
hold off;

figure;
hold on;
plot(t, Theta);
xlabel("Temps (en s)");
ylabel('Angle Theta (en °)');
legend('Theta');
title('Angle de rotation θ des quaternions en fonction du temps');
hold off;

figure;
hold on;
plot(t, Lx);
plot(t, Ly);
plot(t, Lz);
xlabel("Temps (en s)");
ylabel('Accélération linéaire (en m/s²)');
legend('Lx', 'Ly', 'Lz');
title('Accélérations linéaires en fonction du temps');
hold off;

figure;
hold on;
plot(t, Ax);
plot(t, Ay);
plot(t, Az);
xlabel("Temps (en s)");
ylabel('Accélération angulaire (en rad/s^2)');
legend('Ax', 'Ay', 'Az');
title('Accélérations angulaires en fonction du temps');
hold off;

figure;
hold on;
plot(t, Vx);
plot(t, Vy);
plot(t, Vz);
xlabel("Temps (en s)");
ylabel('Vitesse angulaire (en rad/s)');
legend('Vx', 'Vy', 'Vz');
title('Vitesses angulaires en fonction du temps');
hold off;

figure;
hold on;
plot(t, Mx);
plot(t, My);
plot(t, Mz);
xlabel("Temps (en s)");
ylabel('Champ magnétique (en µT)');
legend('Mx', 'My', 'Mz');
title('Champs magnétiques en fonction du temps');
hold off;

figure;
hold on;
plot(t, T);
xlabel("Temps (en s)");
ylabel('Température (en °C)');
legend('T');
title('Température en fonction du temps');
hold off;

figure;
hold on;
plot(t, D1);
plot(t, D2);
xlabel("Temps (en s)");
ylabel('Distance main-support (en m)');
legend('D1', 'D2');
title('Distances entre les mains et le support en fonction du temps');
hold off;

%% II - Etude Fréquentielle
%  ************************

t1 = data(Debut:Fin, 1) - data(Debut, 1);

% Angles d'Euler
% --------------

Ex = data(Debut:Fin, 2);
Ey = data(Debut:Fin, 3);
Ez = data(Debut:Fin, 4);

F_Ex = fft(Ex);
F_Ey = fft(Ey);
F_Ez = fft(Ez);

% Accélérations linéaires
% -----------------------

Lx = data(Debut:Fin, 5);
Ly = data(Debut:Fin, 6);
Lz = data(Debut:Fin, 7);

F_Lx = fft(Lx);
F_Ly = fft(Ly);
F_Lz = fft(Lz);

% Accélérations angulaires
% ------------------------

Ax = data(Debut:Fin, 8);
Ay = data(Debut:Fin, 9);
Az = data(Debut:Fin, 10);

F_Ax = fft(Ax);
F_Ay = fft(Ay);
F_Az = fft(Az);

% Vitesses angulaires
% -------------------

Vx = data(Debut:Fin, 11);
Vy = data(Debut:Fin, 12);
Vz = data(Debut:Fin, 13);

F_Vx = fft(Vx);
F_Vy = fft(Vy);
F_Vz = fft(Vz);

% Champs magnétiques
% ------------------

Mx = data(Debut:Fin, 14);
My = data(Debut:Fin, 15);
Mz = data(Debut:Fin, 16);

F_Mx = fft(Mx);
F_My = fft(My);
F_Mz = fft(Mz);

% Quaternions
% -----------

Qw = data(Debut:Fin, 17);
Qx = data(Debut:Fin, 18);
Qy = data(Debut:Fin, 19);
Qz = data(Debut:Fin, 20);

F_Qw = fft(Qw);
F_Qx = fft(Qx);
F_Qy = fft(Qy);
F_Qz = fft(Qz);

% Température
% -----------

T = data(Debut:Fin, 21);

F_T = fft(T);

% Distances entre les mains et le support
% ---------------------------------------

D1 = data(Debut:Fin, 22);
D2 = data(Debut:Fin, 23);

F_D1 = fft(D1);
F_D2 = fft(D2);

% Angles de rotation quaternions
% ------------------------------

Theta = 2*acos(Qw)*180/pi;
QX = Qx*1/(sqrt(1-Qw.^2))*Theta;
QY = Qy*1/(sqrt(1-Qw.^2))*Theta;
QZ = Qz*1/(sqrt(1-Qw.^2))*Theta;

F_QX = fft(QX);
F_QY = fft(QY);
F_QZ = fft(QZ);
F_Theta = fft(Theta);

% Angles de rotation Euler-Quaternions
% ------------------------------------

Th = acos(1-2*(Qx.^2+Qy.^2))*180/pi;
Ph = atan2(Qx.*Qz-Qy.*Qw, Qy.*Qz+Qx.*Qw)*180/pi;
Ps = atan2(Qx.*Qz+Qy.*Qw, Qy.*Qz-Qx.*Qw)*180/pi;

F_Th = fft(Th);
F_Ph = fft(Ph);
F_Ps = fft(Ps);

% Angles de rotation Elémentaire-Quaternions
% ------------------------------------------

X = atan2(2*(Qy.*Qz+Qx.*Qw), 1-2*(Qx.^2+Qy.^2))*180/pi;
Y = asin(2*(Qy.*Qw-Qx.*Qz))*180/pi;
Z = atan2(2*(Qx.*Qy+Qz.*Qw), 1-2*(Qy.^2+Qz.^2))*180/pi;

F_X = fft(X);
F_Y = fft(Y);
F_Z = fft(Z);

% -------------------------------------------------------------------------

% Plots
% -----

figure;
subplot(3,2,1);
hold on;
plot(t1, QX);
plot(t1, Ex);
plot(t1, Th);
plot(t1, X);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('X Quaterion', 'X Euler', 'X Euler-Quaternions', 'X Elementaire-Quaternions');
title('Rotations autour de X en fonction du temps');
hold off;

subplot(3,2,2);
hold on;
plot(Fs/L*(0:L), abs(F_QX));
plot(Fs/L*(0:L), abs(F_Ex));
plot(Fs/L*(0:L), abs(F_Th));
plot(Fs/L*(0:L), abs(F_X));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('X Quaterion', 'X Euler', 'X Euler-Quaternions', 'X Elementaire-Quaternions');
title('Transformée de Fourier des rotations autour de X');
hold off;

subplot(3,2,3);
hold on;
plot(t1, QY);
plot(t1, Ey);
plot(t1, Ph);
plot(t1, Y);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Y Quaterion', 'Y Euler', 'Y Euler-Quaternions', 'Y Elementaire-Quaternions');
title('Rotations autour de Y en fonction du temps');
hold off;

subplot(3,2,4);
hold on;
plot(Fs/L*(0:L), abs(F_QY));
plot(Fs/L*(0:L), abs(F_Ey));
plot(Fs/L*(0:L), abs(F_Ph));
plot(Fs/L*(0:L), abs(F_Y));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Y Quaterion', 'Y Euler', 'Y Euler-Quaternions', 'Y Elementaire-Quaternions');
title('Transformée de Fourier des rotations autour de Y');
hold off;

subplot(3,2,5);
hold on;
plot(t1, QZ);
plot(t1, Ez);
plot(t1, Ps);
plot(t1, Z);
xlabel("Temps (en s)");
ylabel('Angle de rotation (en °)');
legend('Z Quaterion', 'Z Euler', 'Z Euler-Quaternions', 'Z Elementaire-Quaternions');
title('Rotations autour de Z en fonction du temps');
hold off;

subplot(3,2,6);
hold on;
plot(Fs/L*(0:L), abs(F_QZ));
plot(Fs/L*(0:L), abs(F_Ez));
plot(Fs/L*(0:L), abs(F_Ps));
plot(Fs/L*(0:L), abs(F_Z));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Z Quaterion', 'Z Euler', 'Z Euler-Quaternions', 'Z Elementaire-Quaternions');
title('Transformée de Fourier des rotations autour de Z en fonction du temps');
hold off;

figure;
subplot(3,2,1);
hold on;
plot(t1, Lx);
plot(t1, Ly);
plot(t1, Lz);
xlabel("Temps (en s)");
ylabel('Accélération linéaire (en m/s²)');
legend('Lx', 'Ly', 'Lz');
title('Accélérations linéaires en fonction du temps');
hold off;

subplot(3,2,2);
hold on;
plot(Fs/L*(0:L), abs(F_Lx));
plot(Fs/L*(0:L), abs(F_Ly));
plot(Fs/L*(0:L), abs(F_Lz));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Lx', 'Ly', 'Lz');
title('Transformée de Fourier des accélérations linéaires');
hold off;

subplot(3,2,3);
hold on;
plot(t1, Ax);
plot(t1, Ay);
plot(t1, Az);
xlabel("Temps (en s)");
ylabel('Accélération angulaire (en rad/s^2)');
legend('Ax', 'Ay', 'Az');
title('Accélérations angulaires en fonction du temps');
hold off;

subplot(3,2,4);
hold on;
plot(Fs/L*(0:L), abs(F_Ax));
plot(Fs/L*(0:L), abs(F_Ay));
plot(Fs/L*(0:L), abs(F_Az));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Ax', 'Ay', 'Az');
title('Transformée de Fourier des accélérations angulaires');
hold off;

subplot(3,2,5);
hold on;
plot(t1, Vx);
plot(t1, Vy);
plot(t1, Vz);
xlabel("Temps (en s)");
ylabel('Vitesse angulaire (en rad/s)');
legend('Vx', 'Vy', 'Vz');
title('Vitesses angulaires en fonction du temps');
hold off;

subplot(3,2,6);
hold on;
plot(Fs/L*(0:L), abs(F_Vx));
plot(Fs/L*(0:L), abs(F_Vy));
plot(Fs/L*(0:L), abs(F_Vz));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Vx', 'Vy', 'Vz');
title('Transformée de Fourier des Vitesse angulaires');
hold off;

figure;
subplot(4,2,1);
hold on;
plot(t1, Theta);
xlabel("Temps (en s)");
ylabel('Angle Theta (en °)');
legend('Theta');
title('Angle de rotation θ des quaternions en fonction du temps');
hold off;

subplot(4,2,2);
hold on;
plot(Fs/L*(0:L), abs(F_Theta));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Theta');
title('Transformée de Fourier de l-angle de rotation θ des quaternions');
hold off;

subplot(4,2,3);
hold on;
plot(t1, Mx);
plot(t1, My);
plot(t1, Mz);
xlabel("Temps (en s)");
ylabel('Champ magnétique (en µT)');
legend('Mx', 'My', 'Mz');
title('Champs magnétiques en fonction du temps');
hold off;

subplot(4,2,4);
hold on;
plot(Fs/L*(0:L), abs(F_Mx));
plot(Fs/L*(0:L), abs(F_My));
plot(Fs/L*(0:L), abs(F_Mz));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('Mx', 'My', 'Mz');
title('Transformée de Fourier des champs magnétiques');
hold off;

subplot(4,2,5);
hold on;
plot(t1, T);
xlabel("Temps (en s)");
ylabel('Température (en °C)');
legend('T');
title('Température en fonction du temps');
hold off;

subplot(4,2,6);
hold on;
plot(Fs/L*(0:L), abs(F_T));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('T');
title('Transformée de Fourier de la température');
hold off;

subplot(4,2,7);
hold on;
plot(t1, D1);
plot(t1, D2);
xlabel("Temps (en s)");
ylabel('Distance main-support (en m)');
legend('D1', 'D2');
title('Distances entre les mains et le support en fonction du temps');
hold off;

subplot(4,2,8);
hold on;
plot(Fs/L*(0:L), abs(F_D1));
plot(Fs/L*(0:L), abs(F_D2));
xlabel("Fréquence (en Hz)");
ylabel("|fft|");
legend('D1', 'D2');
title('Transformée de Fourier des distances entre les mains et le support');
hold off;

%% III - Mesure de la mâtrise
%  **************************

% Maîtrise des mains
% ==================

% Méthode 1 - Autocorrélation
% ---------------------------

% On calcule l'autocorrélation de les transformées de Fourier de D1 et D2.
[cFD1,lagsFD1] = xcorr(abs(F_D1));
[cFD2,lagsFD2] = xcorr(abs(F_D2));

% On normalise les autocorrélations.
cFD1 = cFD1/max(cFD1)*100;
cFD2 = cFD2/max(cFD2)*100;

% On retire l'autocorrélation au décalage 0.
[M1,I] = max(cFD1);
cFD1(I) = [];
lagsFD1(I) = [];

[M2,I] = max(cFD2);
cFD2(I) = [];
lagsFD2(I) = [];

% Méthode 2 - Intercorrélation signal théorique
% ---------------------------------------------

% On génère deux bruits blancs gaussien de moyenne nulle.
Bd1 = randn(L+1, 1)*varianceD;
Bd2 = randn(L+1, 1)*varianceD;

% On génère les constantes à partir des moyennes des premiers termes.
Cd1m = mean(D1(1:C_Indice));
Cd1 = ones(L+1,1)*Cd1m;

Cd2m = mean(D2(1:C_Indice));
Cd2 = ones(L+1,1)*Cd2m;

% On génère un sinus dont les paramètres sont modifiables.
Sin = sin(1.5*pi*t1+Phase*pi/180);

% On génère les signaux théoriques en faisant la somme de nos parties.
D1_th = Cd1 + Bd1;
D2_th = Cd2 + Bd2;

% On calcule les intercorrélations des D et D_Th.
[cD1,lagsD1] = xcorr(D1,D1_th);
[cD2,lagsD2] = xcorr(D2,D2_th);

% On normalise les intercorrélations.
cD1 = cD1/max(cD1)*100;
cD2 = cD2/max(cD2)*100;

% Maîtrise du buste
% =================

% Méthode 1 - Jerk
% ----------------

% On initialse le delta t1 entre deux mesures.
delta_t1 = zeros(L,1);

% On initialise les delta A entre deux mesures.
delta_Ax = zeros(L,1);
delta_Ay = zeros(L,1);
delta_Az = zeros(L,1);

% On calcule les delta t1 et A entre deux mesures.
for k = 2:(L+1)
    delta_t1(k-1) = t1(k) - t1(k-1);
    delta_Ax(k-1) = Ax(k) - Ax(k-1);
    delta_Ay(k-1) = Ay(k) - Ay(k-1);
    delta_Az(k-1) = Az(k) - Az(k-1);
end

% On calcule les jerks avec le rapport entre les delta et les delta t.
d_Ax = delta_Ax./delta_t1;
d_Ay = delta_Ay./delta_t1;
d_Az = delta_Az./delta_t1;

% Méthode 2 - Intercorrélation signal théorique
% ---------------------------------------------

% On génère deux bruits blancs gaussien de moyenne nulle.
Bx = randn(L+1, 1)*varianceA;
By = randn(L+1, 1)*varianceA;
Bz = randn(L+1, 1)*varianceA;

% On génère les constantes à partir des moyennes des premiers termes.
Cxm = mean(Ax(1:C_Indice));
Cx = ones(L+1,1)*Cxm;

Cym = mean(Ay(1:C_Indice));
Cy = ones(L+1,1)*Cym;

Czm = mean(Az(1:C_Indice));
Cz = ones(L+1,1)*Czm;

% On génère les signaux théoriques en faisant la somme de nos parties.
Ax_th = Cx + Bx;
Ay_th = Cy + By;
Az_th = Cz + Bz;

% On calcule les intercorrélations des A et A_Th.
[cAx,lagsAx] = xcorr(Ax,Ax_th);
[cAy,lagsAy] = xcorr(Ay,Ay_th);
[cAz,lagsAz] = xcorr(Az,Az_th);

% On normalise les intercorrélations.
cAx = cAx/max(abs(cAx))*100;
cAy = cAy/max(abs(cAy))*100;
cAz = cAz/max(abs(cAz))*100;

% Plots
% -----

figure;
subplot(4,2,[1 3]);
hold on;
plot(t1, D1);
plot(t1, D2);
xlabel("Temps (en s)");
ylabel('Distance main-support (en m)');
legend('D1', 'D2');
title('Distances entre les mains et le support en fonction du temps');
hold off;

subplot(4,2,[2 4]);
hold on;
stem(lagsFD1(end/2:end),cFD1(end/2:end));
stem(lagsFD2(end/2:end),cFD2(end/2:end));
xlabel('Décalages');
ylabel('%');
legend('F_{D1}', 'F_{D2}');
title('Maîtrise des mains - Autocorrélation ');
hold off;

subplot(4,2,[5 7]);
hold on;
plot(t1,D1_th);
plot(t1,D2_th);
xlabel('Temps (en s)');
ylabel('D (en m)');
legend('D1_{Th}', 'D2_{Th}');
title('Distances théoriques entre les mains et le support en fonction du temps');
hold off;

subplot(4,2,[6 8]);
hold on;
stem(lagsD1,cD1);
stem(lagsD2,cD2);
xlabel('Décalages');
ylabel('%');
legend('D1', 'D2');
title('Maîtrise des mains - Intercorrélation signal théorique');
hold off;

figure;
subplot(4,2,[1 3]);
hold on;
plot(t1, Ax);
plot(t1, Ay);
plot(t1, Az);
xlabel('Temps (en s)');
ylabel('Accélération angulaire (en rad/s^2)');
legend('Ax', 'Ay', 'Az');
title('Accélérations angulaires en fonction du temps');
hold off;

subplot(4,2,[2 4]);
hold on;
plot(t1(2:end), d_Ax);
plot(t1(2:end), d_Ay);
plot(t1(2:end), d_Az);
xlabel('Temps (en s)');
ylabel('Jerk (en rad/s^3)');
legend('d_{Ax}', 'd_{Ay}', 'd_{Az}');
title('Maîtrise du buste - Jerk');
hold off;

subplot(4,2,[5 7]);
hold on;
plot(t1,Ax_th);
plot(t1,Ay_th);
plot(t1,Az_th);
xlabel('Temps (en s)');
ylabel('Accélération angulaire théorique (en rad/s^2)');
legend('Ax_{Th}', 'Ay_{Th}', 'Az_{Th}');
title('Accélérations angulaires théoriques en fonction du temps');
hold off;

subplot(4,2,[6 8]);
hold on;
stem(lagsAx,cAx);
stem(lagsAy,cAy);
stem(lagsAz,cAz);
xlabel('Décalages');
ylabel('%');
legend('Ax', 'Ay', 'Az');
title('Maîtrise du buste - Intercorrélation signal théorique');
hold off;