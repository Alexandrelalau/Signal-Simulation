% *********************** PROBLEME 1-B ***********************
% G4E

% Réinitialisation des valeurs
clear
clc

% Fréquence d'échantillonnage
Fe = 64000;
Te = 1/Fe;

% Génération des amplitudes aléatoires entre 1 et 5
A1 = randi([1 5]);
A2 = randi([1 5]);

% Génération des fréquences aléatoires entre 130 Hz et 4000 Hz
f1 = randi([130 4000]);
f2 = randi([130 4000]);

% Génération des phases aléatoires entre 0° et 180°
p1 = rand*pi;
p2 = rand*pi;

% On affiche les signaux sur une durée de 0.01 s
t = 0:Te:0.02;;

% Signaux X1 et X2
X1 = A1*cos(2*pi*f1*t + p1);
X2 = A2*cos(2*pi*f2*t + p2);

% Affichage des signaux
subplot(2,1,1)
plot(t,X1)
hold on
plot(t,X2)
axis([0 0.02 -5 5]);
xlabel('Temps (s)')
ylabel('Amplitude')
title('Signaux X1 et X2')
legend('X1','X2')

% Intercorrélation normalisée (entre 0 et 1)
[a,b]=xcorr(X1,X2,'normalized');

% Affichage de l'intercorrélation des signaux
subplot(2,1,2)
plot(b,a)
axis([-1000 1000 -1 1]);
xlabel('Décalage')
ylabel("Intercorrélation normalisée")
title('Intercorrélation entre X1 et X2')
legend('Intercorrélation')

% Maximum absolu de l'intercorrélation
interMax = max(abs(min(a)),max(a));

% Affichage du résultat dans la fenêtre de commande
if interMax > 0.9
    disp('Les signaux sont presque identiques.')
    disp(['Pourcentage de ressemblance : ',num2str(interMax*100),' %.'])
    disp(['f1 = ',num2str(f1),' Hz et f2 = ',num2str(f2),' Hz.'])
    disp('1')
elseif interMax < 0.9
    disp('Les signaux ne sont pas identiques.')
    disp(['Pourcentage de ressemblance : ',num2str(interMax*100),' %.'])
    disp(['f1 = ',num2str(f1),' Hz et f2 = ',num2str(f2),' Hz.'])
    disp('0')
end

Les signaux ne sont pas identiques.
Pourcentage de ressemblance : 0.7182 %.
f1 = 3208 Hz et f2 = 853 Hz.
0
