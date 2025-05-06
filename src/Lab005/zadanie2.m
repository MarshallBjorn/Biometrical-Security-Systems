%% Krok 1: Wczytanie i przygotowanie obrazu tęczówki
close all; clear; clc;

I = imread('oko1.jpg');
if size(I, 3) == 3
    I = rgb2gray(I);
end
I = im2double(I);

figure; imshow(I, []);
title('Oryginalny obraz znormalizowanej tęczówki');
exportgraphics(gcf, 'zad2_iris_original.png', 'Resolution', 300);

%% Krok 2: FFT 2D i przesunięcie widma
F = fft2(I);
F_shifted = fftshift(F);
magF = log(1 + abs(F_shifted));

figure; imshow(magF, []);
title('Widmo częstotliwości (log)');
exportgraphics(gcf, 'zad2_iris_fft_spectrum.png', 'Resolution', 300);

%% Krok 3: Maska filtru
[rows, cols] = size(I);
[u, v] = meshgrid(-floor(cols/2):floor((cols-1)/2), -floor(rows/2):floor((rows-1)/2));
D = sqrt(u.^2 + v.^2);
D_low = 5;
D_high = 25;

H = double(D > D_low & D < D_high);

figure; imshow(H, []);
title('Maska filtru środkowoprzepustowego');
exportgraphics(gcf, 'zad2_iris_filter_mask.png', 'Resolution', 300);

%% Krok 4: Zastosowanie filtru
F_filtered = F_shifted .* H;

%% Krok 5: Odwrotna FFT
I_filtered = real(ifft2(ifftshift(F_filtered)));
I_filtered = mat2gray(I_filtered);

%% Krok 6: Porównanie obrazów
figure;
subplot(1,2,1); imshow(I, []); title('Oryginalna tęczówka');
subplot(1,2,2); imshow(I_filtered, []); title('Tęczówka po filtracji Fouriera');
exportgraphics(gcf, 'zad2_iris_comparison.png', 'Resolution', 300);

%% Krok 7: Powierzchnia przefiltrowanego obrazu
figure;
mesh(I_filtered);
title('Topologia obrazu w płaszczyźnie biegunowej');
exportgraphics(gcf, 'zad2_iris_surface_plot.png', 'Resolution', 300);
