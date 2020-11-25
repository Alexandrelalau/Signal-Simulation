% ***************************** PROBLEME 2 *******************************
% G4E
% Algorithme 3 - Analyse fréquentielle et temporelle

% Réinitialisation des variables
close
clear
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
[X, Fs] = audioread(A);

Ts = 1/Fs;              % Période d'échantillonnage
L = length(X);          % Longueur du signal
t = 0:Ts:10-Ts;         % Vecteur de temps

X = X - mean(X);        % On enlève la composante continue

% Affichage du signal
subplot(2,1,1)
plot(t,X)
xlabel('Temps (s)')
ylabel('Amplitude (V)')
title('X(t)')

% Fenêtre temporelle *****************************************************

% La fenêtre temporelle a une largeur égale à la durée du battement le plus
% long, c'est-à-dire 40 bpm selon le cahier des charges (0.66 Hz = 40 bpm).

largeurFenetre = 1/0.66;                    % Largeur de la fenêtre en seconde
indexFenetre = round(largeurFenetre*Fs);    % Largeur de la fenêtre en échantillon
nbFenetre = ceil(length(X)/indexFenetre);   % Nombre de fenêtres

% Boucle fenêtre glissante ***********************************************

nbBPM = 1;                  % Index vecteur BPM
y = zeros(1,nbFenetre-1);   % Vecteur BPM vide

for i = 1:indexFenetre:L-indexFenetre
    
    % Valeur du signal sur la fenêtre
    fenetreX = X(i:i+indexFenetre-1);
    
    % Zero-padding de la fenêtre
    paddingX = [fenetreX.',zeros(1,999*length(fenetreX))];
    
    % FFT de la fenêtre après zero-padding en dB
    FFTpaddingX = 20*log10(abs(fft(fenetreX,1000*length(fenetreX))));

    % Autocorrélation de la FFT
    [a,b] = xcorr(FFTpaddingX);
    
    % On cherche les pics dans l'autocorrélation de la FFT
    [value,loc] = findpeaks(a);
    
    % On détermine la fréquence
    freq = (loc(ceil(length(loc)/2)+1) - loc(ceil(length(loc)/2)-1)) / length(loc) * Fs;
    
    % On ajoute la valeur de bpm à un vecteur
    y(nbBPM) = (freq*L)/100000;
    
    % On incrémente le 
    nbBPM = nbBPM + 1;
   
end

% Affichage du rythme cardiaque ******************************************
subplot(2,1,2)
plot(y,'r')
axis([1 inf 40 140])
ylabel('Fréquence cardiaque (bpm)')
title('Rythme cardiaque')

% Affichage des résultats ************************************************
disp('Valeurs relevées :')
disp(y)
disp('Moyenne :')
disp(mean(y))

