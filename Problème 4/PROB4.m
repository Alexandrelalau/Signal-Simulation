% ***************************** PROBLEME 4 *******************************
% G4E
% Reconnaissance de tonalité - Version 1


% Réinitialisation des variables
clear
close
clc


% Génération du signal de référence **************************************

% Fréquence audible max = 20 KHz donc d'après les conditions de Shannon :
Fe = 40000;
Te = 1/Fe;

% Génération d'une fréquence aléatoire dans les gammes 2 à 6
n0 = randsample(60,1);
f0 = 123.47*2^(n0/12);

disp(['Fréquence générée : ',num2str(f0),' Hz'])

t = 0:Te:3;         % Vecteur de temps sur 3 secondes

% Génération d'une amplitude aléatoire
A0 = randi([1 7]);

% Signal sinusoïdale
x = A0*sin(2*f0*pi*t);

% Signal carré
xSquare = square(2*f0*pi*t);

L = length(x);      % Longueur du signal


% Génération du signal de l'utilisateur **********************************

A1 = randi([4 7]);   % Amplitude aléatoire principale
A2 = randi([2 3]);   % Amplitude aléatoire du bruit 1
A3 = randi([1 2]);   % Amplitude aléatoire du bruit 2

% Fréquence aléatoire principale
f1 = randi([123 4186]);

% Fréquence aléatoire du bruit supérieure à f1
f2 = 0;

while f2 < f1
    f2 = randi([0 20000]);
end

% Fréquence aléatoire du bruit supérieure à f2
f3 = 0;

while f3 < f2
    f3 = randi([0 20000]);
end

% Génération d'offset aléatoire entre 0 s et 0.01 s
D1 = 0.01 * rand;
D2 = 0.01 * rand;
D3 = 0.01 * rand;

% Création des signaux
X1 = A1*cos(2*f1*pi*t + D1);
X2 = A2*cos(2*f2*pi*t + D2);
X3 = A3*cos(2*f3*pi*t + D3);

% Addition des signaux pour créer celui de l'utilisateur
X = X1 + X2 + X3;

% Ajout d'un temps aléatoire (0 s à 1 s) au début du signal
T = 1/Te*rand;

for i = 1:T
    X(i) = 0;
end


% Filtrage des fréquences entre 123 Hz et 4186 Hz (octaves 2 à 6) ********

% Note : le filtre n'a pas de réel usage ici car le signal généré pour
% l'utilisateur est déjà dans ces fréquences.

load('gamme2to6pass.mat');  % Chargement du filtre

xFiltered = filter(h,1,X);  % Utilisation du filtre


% Détection du signal utile **********************************************
% Demandé par l'énoncé mais pas nécessaire ?


% Affichage des signaux **************************************************

subplot(3,1,2)
plot(t,x)
hold on
plot(t,xFiltered)
axis([0 inf -inf inf])
xlabel('Temps (s)')
ylabel('Amplitude (V)')
title('Signaux')
legend('Signal généré','Signal utilisateur')

subplot(3,2,1)
plot(t,X)
axis([0 inf -inf inf])
xlabel('Temps (s)')
ylabel('Amplitude (V)')
title('Signal utilisateur brut')

subplot(3,2,2)
plot(t,xFiltered)
axis([0 inf -inf inf])
xlabel('Temps (s)')
ylabel('Amplitude (V)')
title('Signal utilisateur filtré')


% FFT de X(t) ************************************************************

Y = fft(xFiltered);                     
P2 = 20*log10(abs(Y/L));        % Module de la FFT en dB
P1 = P2(1:round(L/2));          % On garde qu'un côté du module
P1(2:end-1) = 2*P1(2:end-1);    % On multiplie par 2

f = Fe*(0:(L/2))/L;             % Vecteur de fréquence

% Affichage de la FFT
subplot(3,1,3)
plot(f,P1)
axis([0 4186 -200 50])
xlabel('Fréquence (Hz)')
ylabel('Amplitude (dB)')
title("FFT du signal utilisateur")
legend('FFT du signal')


% Analyse de la FFT ******************************************************

[value,position] = max(P1);     % Détection de la fondamentale

fPlayed = position/3;           % Récupération de la fréquence en Hz

disp(['Fréquence jouée : ',num2str(fPlayed),' Hz'])


% Détection de la note générée *******************************************

notes = ["do","do#","re","re#","mi","fa","fa#","sol","sol#","la","la#","si"];

note = mod(n0,12);                  % Récupération du numéro de la note
octave = (n0 - mod(n0,12))/12 + 2;  % Récupération du numéro de l'octave

if note == 0    % Si la note vaut zéro c'est qu'il s'agit de la fin d'un octave
   note = 12;
   octave = octave - 1;
end

disp(' ')
disp(['La note générée est un ',num2str(notes(note)),' octave ',num2str(octave)])


% Détection de la note jouée *********************************************

nPlayed = round(12*(log(fPlayed/123.47)/log(2)));   % Calcul du numéro de la note

note2 = mod(nPlayed,12);                        % Récupération du numéro de la note
octave2 = (nPlayed - mod(nPlayed,12))/12 + 2;   % Récupération du numéro de l'octave

if note2 == 0   % Si la note vaut zéro c'est qu'il s'agit de la fin d'un octave
   note2 = 12;
   octave2 = octave2 - 1;
end

disp(['La note jouée est un ',num2str(notes(note2)),' octave ',num2str(octave2)])

% Système de notation ****************************************************

% On calcul l'écart absolu entre deux notes. Si ce sont les mêmes
% l'utilisateur a 10 points. Il perd ensuite X point dès qu'il joue X notes
% au dessus ou en dessous de la note générée. S'il est à plus de 10 notes
% d'écart il a 0 points.

% S'il joue exactement la même note mais dans une octave différente il perd
% 2 points par octave de différence.

delta = abs(n0 - nPlayed);          % Écart entre les notes jouées
delta2 = abs(octave - octave2);     % Écart entre les octaves jouées

disp(' ')

if octave == octave2
    if delta == 0
        grade = 10;
        disp('FÉLICITATIONS !! Vous avez joué exactement la même note ! 10/10')    
    elseif delta < 10
        grade = 10 - delta;
        disp(['Bien joué ! Vous avez : ',num2str(grade),'/10'])
    else
        disp('Retentez votre chance... Vous avez 0/10')
    end
elseif note == note2
       grade = 10 - 2*delta2;
       disp(['Bien joué ! Vous avez : ',num2str(grade),'/10'])
else
    disp('Retentez votre chance... Vous avez 0/10')
end
