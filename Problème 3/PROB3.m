% ***************************** PROBLEME 3 *******************************
% G4E
% Gamme chromatique

% Réinitialisation des variables *****************************************
clear
close
clc

% Chargement des fichiers
A = 'Fl_A4_96K.wav';    % Flûte traversière
B = 'Pi_A_96K.wav';     % Piano
C = 'Vi_A3_96K.wav';    % Violon

% Audioread (remplacer le nom par le fichier à lire)
[x, Fs] = audioread(A);

xMono = mean(x,2);      % Stéréo vers mono
L = length(xMono);      % Longueur du fichier
Ts = 1/Fs;              % Période d'échantillonnage
Tmax = (L-1)*Ts;        % Duree du signal
t = 0:Ts:Tmax;          % Vecteur de temps

% Affichage du signal
plot(t,xMono)
axis([0 inf -inf inf])
xlabel('Temps (s)')
ylabel('Amplitude (V)')
title('xMono(t)')

% Boucle de synthétisation
for i = -8:3
  coef_frequence = 2^(i/12);        % La nouvelle fréquence est égale à la fréquence de la note xMono fois ce coefficient
  t2 = [0:L-1]*Ts*coef_frequence;   % Vecteur de temps décimé
  x2 = interp1(t,xMono,t2);         % Signal interpolé
  sound(x2,Fs)                      % Lecture audio
  pause(2.1);                       
end