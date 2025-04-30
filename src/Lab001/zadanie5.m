% Wczytanie obrazu i konwersja do skali szarości
rgbImage = imread('cameraman.jpg');
grayImage = rgb2gray(rgbImage);

% Wyznaczenie 2 progów metodą Otsu (wieloprogowość)
thresholds = multithresh(grayImage, 2);  % [t1, t2]

% Segmentacja obrazu na 3 klasy
segmentedImage = imquantize(grayImage, thresholds);

% Kolorowanie klas dla wizualizacji
rgbSegmented = label2rgb(segmentedImage, 'jet', 'k');

% Binaryzacja klasyczna dla porównania
binaryImage = imbinarize(grayImage, graythresh(grayImage));

% Wyświetlenie wyników
figure;
subplot(2,2,1), imshow(grayImage), title('Oryginalny obraz (gray)');
subplot(2,2,2), imshow(binaryImage), title('Binaryzacja jednokryterialna');
subplot(2,2,3), imshow(segmentedImage, []), title('Obraz segmentowany (3 klasy)');
subplot(2,2,4), imshow(rgbSegmented), title('Segmentacja wieloprogowa (kolor)');

% Zapis obrazów (opcjonalny)
imwrite(binaryImage, 'zadanie5images/binaryzacja_otsu.png');
imwrite(rgbSegmented, 'zadanie5images/segmentacja_wieloprogowa.png');
