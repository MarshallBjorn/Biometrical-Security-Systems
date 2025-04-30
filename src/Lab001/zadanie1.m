% Wczytaj obraz RGB
rgbImage = imread('colors.jpg');  % użyj dowolnego obrazu RGB
imshow(rgbImage);
title('Obraz oryginalny RGB');

% 1. Konwersja do obrazu monochromatycznego (odcienie szarości)
grayImage = rgb2gray(rgbImage);
figure, imshow(grayImage);
title('Obraz monochromatyczny');

% 2. Binaryzacja obrazu (konwersja do obrazu binarnego)
binaryImage = imbinarize(grayImage);
figure, imshow(binaryImage);
title('Obraz binarny');

% 3. Konwersja do obrazu indeksowanego (indeks + mapa kolorów)
[indexedImage, colormap] = rgb2ind(rgbImage, 256); % 256 kolorów
figure, imshow(indexedImage, colormap);
title('Obraz indeksowany');

% 4. Wyodrębnienie kanałów RGB
redChannel = rgbImage(:, :, 1);
greenChannel = rgbImage(:, :, 2);
blueChannel = rgbImage(:, :, 3);

figure,
subplot(1,3,1), imshow(redChannel), title('Kanał czerwony');
subplot(1,3,2), imshow(greenChannel), title('Kanał zielony');
subplot(1,3,3), imshow(blueChannel), title('Kanał niebieski');

% 5. Zapis do plików
imwrite(rgbImage, 'zadanie1images/obraz_rgb.png');
imwrite(grayImage, 'zadanie1images/obraz_szary.png');
imwrite(binaryImage, 'zadanie1images/obraz_binarny.png');
imwrite(indexedImage, colormap, 'zadanie1images/obraz_indeksowany.png');

% Zapis kanałów RGB
imwrite(redChannel, 'zadanie1images/kanal_czerwony.png');
imwrite(greenChannel, 'zadanie1images/kanal_zielony.png');
imwrite(blueChannel, 'zadanie1images/kanal_niebieski.png');