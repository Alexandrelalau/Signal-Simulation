% *********************** PROBLEME 1-A ***********************
% G4E

% Réinitialisation des valeurs
clear
clc

% Chargement des fichiers
A = 'BonneJournee.wav';
B = 'JBTheme.wav';
C = 'Allegretto.wav';
D = 'Atone.wav';

% Audioread (remplacer le nom par le fichier à lire)
[x, Fs] = audioread(D);

% Stereo vers Mono
xMono = mean(x,2);

% Récupération du nombre d'échantillons
N = length(xMono);

% Création d'un vecteur vide pour stocker la puissance
XX = zeros(1,N);

% Calcul de la période d'échantillonnage
Ts = 1/Fs;

% Calcul du numéro d'échantillon qui correspond à 50 ms
n = 0.05/Ts;

% Calcul de la puissance du bruit sur les 50 premières ms
Pbruit = 0;

for i = 1:n
    Pbruit = Pbruit + (xMono(i)^2);
end

% Moyenne des puissances pour obtenir le seuil
seuil = Pbruit/n;

% Calcul la puissance moyenne pour chaque échantillon
for i = n:N
    if (xMono(i)^2) > seuil
       XX(i) = (xMono(i)^2); 
    end
end

% Affichage du signal audio
subplot(2,1,1)
plot(xMono)
xlabel('Échantillons')
ylabel('Amplitude')
title('Signal sonore')

% Affichage de la présence sonore
subplot(2,1,2)
plot(XX, 'r')
xlabel('Échantillons')
ylabel('Puissance sonore (W)')
title('Présence sonore')
