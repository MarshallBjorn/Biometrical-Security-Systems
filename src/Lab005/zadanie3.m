% Zadanie 3: Filtracja częstotliwościowa odcisku palca
close all; clear; clc;

% Krok 1: Wczytanie obrazu
I = imread('finger.jpg'); % Upewnij się, że plik istnieje w katalogu roboczym
if size(I,3) == 3
    I = rgb2gray(I);
end
I = im2double(I);

% Wyświetlenie oryginalnego obrazu
figure; imshow(I);
title('Oryginalny obraz daktyloskopijny');
exportgraphics(gcf, 'fingerprint_original.png', 'Resolution', 300);

% Krok 2: Obliczenie FFT 2D i przesunięcie środka
F = fft2(I);
F_shifted = fftshift(F);
magnitude = log(1 + abs(F_shifted));

% Widmo częstotliwości
figure; imshow(magnitude, []);
title('Widmo częstotliwości (log)');
exportgraphics(gcf, 'fingerprint_fft_spectrum.png', 'Resolution', 300);

% Krok 3: Maska filtru środkowoprzepustowego
[rows, cols] = size(I);
[u, v] = meshgrid(-floor(cols/2):floor((cols-1)/2), -floor(rows/2):floor((rows-1)/2));
D = sqrt(u.^2 + v.^2);
D_low = 10;
D_high = 60;
H = double(D > D_low & D < D_high);

% Wyświetlenie maski
figure; imshow(H, []);
title('Maska filtru środkowoprzepustowego');
exportgraphics(gcf, 'fingerprint_filter_mask.png', 'Resolution', 300);

% Krok 4: Zastosowanie filtru w dziedzinie częstotliwości
F_filtered = F_shifted .* H;

% Krok 5: Odwrotna FFT - uzyskanie obrazu przefiltrowanego
I_filtered = real(ifft2(ifftshift(F_filtered)));
I_filtered = mat2gray(I_filtered);

% Krok 6: Porównanie wyników
figure;
subplot(1,2,1); imshow(I); title('Oryginalny');
subplot(1,2,2); imshow(I_filtered); title('Po filtracji Fouriera');
exportgraphics(gcf, 'fingerprint_comparison.png', 'Resolution', 300);
