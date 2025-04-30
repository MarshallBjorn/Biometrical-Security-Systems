% Wczytanie obrazu i konwersja do skali szarości
rgbImage = imread('cameraman.jpg');
grayImage = rgb2gray(rgbImage);

% Wyświetlenie histogramu
figure;
imhist(grayImage);
title('Histogram obrazu w skali szarości');

% Segmentacja ręczna przy różnych progach
threshold1 = 80;
threshold2 = 120;
threshold3 = 160;

BW1 = grayImage > threshold1;
BW2 = grayImage > threshold2;
BW3 = grayImage > threshold3;

% Segmentacja automatyczna metodą Otsu
otsuThreshold = graythresh(grayImage);  % zwraca wartość w zakresie [0, 1]
BW_otsu = imbinarize(grayImage, otsuThreshold);

% Wyświetlenie wyników
figure;
subplot(2,3,1), imshow(grayImage), title('Oryginalny obraz');
subplot(2,3,2), imshow(BW1), title(['Próg ręczny = ' num2str(threshold1)]);
subplot(2,3,3), imshow(BW2), title(['Próg ręczny = ' num2str(threshold2)]);
subplot(2,3,4), imshow(BW3), title(['Próg ręczny = ' num2str(threshold3)]);
subplot(2,3,5), imshow(BW_otsu), title(['Otsu (próg = ' num2str(round(otsuThreshold*255)) ')']);

% Zapis wyników (opcjonalnie)
imwrite(BW1, 'zadanie3images/progowanie_80.png');
imwrite(BW2, 'zadanie3images/progowanie_120.png');
imwrite(BW3, 'zadanie3images/progowanie_160.png');
imwrite(BW_otsu, 'zadanie3images/segmentacja_otsu.png');
