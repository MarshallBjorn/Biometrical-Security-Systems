%% Inicjalizacja
close all; clear all; clc;

%% Parametry
roz = 5; % liczba harmonicznych
a = -180:1:180; % przedział w stopniach
t = a * pi / 180; % zamiana na radiany
Tmax = t(end) - t(1); % okres funkcji
krok = t(2) - t(1); % krok próbkowania

%% Generowanie funkcji wejściowej
% y = sin(t) + 0.1*sin(20*t); % sygnał niestandardowy
% y = (t > 0)*2 - 1;         % sygnał prostokątny
% y = t;                     % funkcja liniowa
y = sin(t) + 0.2*cos(5*t) + 0.1*sin(10*t); % sygnał złożony

figure;
plot(t, y, 'g');
title('Oryginalny sygnał');
xlabel('t');
ylabel('Amplitude');
grid on;

exportgraphics(gcf, 'original.png', 'Resolution', 300);

%% Obliczanie współczynników Fouriera
Ao = (1/Tmax) * sum(y .* krok); % współczynnik stały
A = zeros(roz, 1); % współczynniki kosinusowe
B = zeros(roz, 1); % współczynniki sinusowe

for j = 1:roz
    A(j) = sum(y .* cos(j * 2*pi/Tmax * t)) * (2/Tmax) * krok;
    B(j) = sum(y .* sin(j * 2*pi/Tmax * t)) * (2/Tmax) * krok;
end

%% Rekonstrukcja funkcji z harmonicznych
W = Ao / 2 * ones(1, length(t)); % zaczynamy od A0/2
Skc = zeros(roz, length(t)); % kosinusowe składowe
Sks = zeros(roz, length(t)); % sinusowe składowe

for i = 1:roz
    Skc(i,:) = A(i) * cos(i * 2*pi/Tmax * t);
    Sks(i,:) = B(i) * sin(i * 2*pi/Tmax * t);
    W = W + Skc(i,:) + Sks(i,:);
end

%% Wizualizacja składowych i rekonstrukcji
figure;
hold on;
for i = 1:roz
    plot(t, Skc(i,:), 'g--'); % kosinus
    plot(t, Sks(i,:), 'b:');  % sinus
end
plot(t, W, 'r', 'LineWidth', 1.5); % rekonstrukcja
title('Składowe harmoniczne i sygnał zrekonstruowany');
xlabel('t');
ylabel('Amplituda');
legend('cos','sin','Rekonstrukcja');
grid on;
hold off;

exportgraphics(gcf, 'recon_harmon.png', 'Resolution', 300);

%% Porównanie oryginału i rekonstrukcji
figure;
plot(t, y, 'g', 'LineWidth', 1);
hold on;
plot(t, W, 'r--', 'LineWidth', 1.5);
title('Porównanie sygnału oryginalnego i zrekonstruowanego');
legend('Oryginalny', 'Rekonstrukcja');
xlabel('t');
ylabel('Amplituda');
grid on;

exportgraphics(gcf, 'comparison.png', 'Resolution', 300);

%% Wykresy współczynników A i B
figure;
subplot(2,1,1);
stem(1:roz, A, 'filled', 'g');
title('Współczynniki kosinusowe A_n');
xlabel('n'); ylabel('A_n'); grid on;

subplot(2,1,2);
stem(1:roz, B, 'filled', 'r');
title('Współczynniki sinusowe B_n');
xlabel('n'); ylabel('B_n'); grid on;

exportgraphics(gcf, 'coeff.png', 'Resolution', 300);

%% Widmo amplitudowe
figure;
stem(1:roz, sqrt(A.^2 + B.^2), 'filled', 'k');
title('Widmo amplitudowe |C_n|');
xlabel('n'); ylabel('|C_n|');
grid on;

exportgraphics(gcf, 'spectrum.png', 'Resolution', 300);