% Wczytanie obrazu (kolorowego lub w skali szarości)
rgbImage = imread('cameraman.jpg');
grayImage = rgb2gray(rgbImage);  % Konwersja do skali szarości

% Wyświetlenie oryginalnego obrazu i jego histogramu
figure;
subplot(2,2,1), imshow(grayImage), title('Oryginalny obraz (gray)');
subplot(2,2,2), imhist(grayImage), title('Histogram oryginalny');

% Rozciąganie histogramu (stretching)
stretchedImage = imadjust(grayImage, stretchlim(grayImage));
subplot(2,2,3), imshow(stretchedImage), title('Po rozciąganiu histogramu');
subplot(2,2,4), imhist(stretchedImage), title('Histogram po rozciąganiu');

% Wyrównanie histogramu (equalization)
equalizedImage = histeq(grayImage);

% Nowa figura do porównań
figure;
subplot(2,2,1), imshow(equalizedImage), title('Po wyrównaniu histogramu');
subplot(2,2,2), imhist(equalizedImage), title('Histogram po wyrównaniu');
subplot(2,2,3), imshowpair(stretchedImage, equalizedImage, 'montage');
title('Porównanie: Rozciągnięty vs Wyrównany');

% Zapis obrazów (opcjonalnie)
imwrite(grayImage, 'zadanie2images/obraz_szary.png');
imwrite(stretchedImage, 'zadanie2images/obraz_stretched.png');
imwrite(equalizedImage, 'zadanie2images/obraz_equalized.png');
