% Tworzenie katalogu, jeśli nie istnieje
outputFolder = 'zadanie1images';
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% Wczytaj obraz biometryczny
I = imread('oko1.png');
I_gray = im2gray(I);
I_gray = im2double(I_gray);

% Definicje masek
roberts_mask = [0 0 0; -1 0 0; 0 1 0];
prewitt_mask = [-1 -1 -1; 0 0 0; 1 1 1];
sobel_mask = [-1 -2 -1; 0 0 0; 1 2 1];
laplace_mask1 = [0 -1 0; -1 4 -1; 0 -1 0];
laplace_mask2 = [-1 -2 -1; -2 4 -2; -1 -2 -1];

%% Filtracja 3x3
figure;
subplot(2,3,1), imshow(I_gray), title('Oryginał');
subplot(2,3,2), imshow(imfilter(I_gray, roberts_mask, 'replicate')), title('Roberts');
subplot(2,3,3), imshow(imfilter(I_gray, prewitt_mask, 'replicate')), title('Prewitt');
subplot(2,3,4), imshow(imfilter(I_gray, sobel_mask, 'replicate')), title('Sobel');
subplot(2,3,5), imshow(imfilter(I_gray, laplace_mask1, 'replicate')), title('Laplace 1');
subplot(2,3,6), imshow(imfilter(I_gray, laplace_mask2, 'replicate')), title('Laplace 2');
sgtitle('Filtracja 3x3');

exportgraphics(gcf, fullfile(outputFolder, 'filtracja_3x3.png'));

%% Filtracja 5x5
hprewitt5 = imresize(fspecial('prewitt'), [5 5], 'nearest');
hsobel5 = imresize(fspecial('sobel'), [5 5], 'nearest');

figure;
subplot(1,2,1), imshow(imfilter(I_gray, hprewitt5, 'replicate')), title('Prewitt 5x5');
subplot(1,2,2), imshow(imfilter(I_gray, hsobel5, 'replicate')), title('Sobel 5x5');
sgtitle('Filtracja 5x5');

exportgraphics(gcf, fullfile(outputFolder, 'filtracja_5x5.png'));

%% Dodanie szumu Salt & Pepper
noisy = imnoise(I_gray, 'salt & pepper', 0.05);

figure;
imshow(noisy);
title('Obraz z szumem Salt & Pepper');

exportgraphics(gcf, fullfile(outputFolder, 'szum_salt_pepper.png'));

%% Filtracja medianowa i uśredniająca
median_filtered = medfilt2(noisy, [3 3]);
average_filtered = imfilter(noisy, fspecial('average', [3 3]), 'replicate');

figure;
subplot(1,3,1), imshow(noisy), title('Obraz zaszumiony');
subplot(1,3,2), imshow(median_filtered), title('Filtr medianowy');
subplot(1,3,3), imshow(average_filtered), title('Filtr uśredniający');
sgtitle('Porównanie filtracji szumu');

exportgraphics(gcf, fullfile(outputFolder, 'filtracja_szumu.png'));

%% Detekcja krawędzi po filtracji
figure;
subplot(1,2,1), imshow(imfilter(median_filtered, sobel_mask, 'replicate')), title('Sobel po medianie');
subplot(1,2,2), imshow(imfilter(average_filtered, sobel_mask, 'replicate')), title('Sobel po uśrednianiu');
sgtitle('Detekcja krawędzi po filtracji');

exportgraphics(gcf, fullfile(outputFolder, 'detekcja_krawedzi_po_filtracji.png'));

%% Filtracja obrazu kolorowego peppers.png
RGB = imread('peppers.png');
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

Rf = imfilter(R, sobel_mask, 'replicate');
Gf = imfilter(G, sobel_mask, 'replicate');
Bf = imfilter(B, sobel_mask, 'replicate');

filtered_RGB = cat(3, Rf, Gf, Bf);

figure;
subplot(1,2,1), imshow(RGB), title('Oryginalny peppers.png');
subplot(1,2,2), imshow(filtered_RGB, []), title('Po filtracji Sobela RGB');
sgtitle('Filtracja obrazu kolorowego');

exportgraphics(gcf, fullfile(outputFolder, 'filtracja_rgb.png'));

%% Porównanie imfilter vs conv2
imf = imfilter(I_gray, sobel_mask, 'same', 'replicate');
convf = conv2(I_gray, sobel_mask, 'same');

figure;
subplot(1,2,1), imshow(imf, []), title('imfilter');
subplot(1,2,2), imshow(convf, []), title('conv2');
sgtitle('Porównanie imfilter vs conv2');

exportgraphics(gcf, fullfile(outputFolder, 'porownanie_imfilter_conv2.png'));
