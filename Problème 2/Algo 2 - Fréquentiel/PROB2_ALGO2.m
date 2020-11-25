% ***************************** PROBLEME 2 *******************************
% G4E
% Algorithme 2 - Analyse frequentielle

% Réinitialisation des variables *****************************************
clear
close
clc

% Chargement des fichiers
A = '100.wav'; % 78 bpm
B = '101.wav'; % 66 bpm
C = '102.wav'; % 72 bpm
D = '103.wav'; % 66 bpm
E = '104.wav'; % 78 bpm
F = '105.wav'; % 84 bpm
G = '106.wav'; % 60 bpm
H = '107.wav'; % 72 bpm
I = '108.wav'; % 66 bpm
J = '109.wav'; % 96 bpm

% Audioread (remplacer le nom par le fichier à lire)
[x, Fe] = audioread(A);


N = length(x); % Nombre d'échantillons
Te = 1/Fe; % Periode d'echantillonnage
tmax = (N-1) * Te; % Duree du signal (s)
t = 0:Te:tmax; % Échantillons temporels (en s)

x = x - mean(x); % on enlève la composante continue 

X = abs(fft(x))/N; % Module de la FFT
X = X';
f = Fe/2 * linspace(0, 1, N);

[Amax, indice] = max(X);
fondamentale = f(indice); % Fréquence fondamentale en Hz
rythme_cardiaque = fondamentale * 60 % Rythme cardiaque en bpm

% Affichage du signal ****************************************************
subplot(2,1,1)
plot(t,X)
xlabel('Temps (s)')
ylabel('Amplitude')
title('Signal x(t)')


