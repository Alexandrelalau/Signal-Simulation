% ***************************** PROBLEME 2 *******************************
% G4E
% Algorithme 1 - Analyse temporelle

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

N = length(x);              % Nombre d'échantillons
Te = 1/Fe;                  % Période d'échantillonnage
t = 0:Te:(N*Te-Te);         % Échantillons temporels

% Calcul de l'écart minimum **********************************************
space = round(0.428/Te);    % 0.428 Hz = 140 bpm

% Extremum
valMax = 0;
valMin = 1;

% Calcul du delta
for i = 1:N
    if x(i) > valMax
       valMax = x(i);
    elseif x(i) < valMin
        valMin = x(i);
    end    
end

delta = 0.5*(valMax - valMin);

% Calcul variation *******************************************************
j0 = 1;
t0 = 0;
nbBPM = 0;

for j = 1:N
    if nbBPM == 0 && abs(x(j) - x(j0)) > delta
        nbBPM = 1;
        j0 = j;
        t0 = j;
    elseif nbBPM > 0 && j - j0 > space && abs(x(j) - x(j0)) < 0.1*delta
        nbBPM = nbBPM + 1;
        j0 = j;
        time = (j-t0)*Te;
        BPM = ((nbBPM-1)*60/time);
        disp(['À ',num2str(time),' s : ',num2str(BPM),' bpm'])
        y(nbBPM) = BPM;
    end
end

% Affichage du signal ****************************************************
subplot(2,1,1)
plot(t,x)
xlabel('Temps (s)')
ylabel('Amplitude')
title('Signal x(t)')

% Affichage du rythme cardiaque ******************************************
subplot(2,1,2)
plot(y,'r')
axis([2 (nbBPM) 40 140])
xlabel('Nombre de battement')
ylabel('Fréquence cardiaque (bpm)')
title('Rythme cardiaque')

% Affichage des résultats ************************************************
disp('Moyenne :')
disp(mean(y))
